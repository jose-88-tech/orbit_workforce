allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.LibraryExtension
            if (android != null) {
                if (android.namespace == null) {
                    android.namespace = when (project.name) {
                        "flutter_windowmanager" -> "io.adaptant.labs.flutter_windowmanager"
                        else -> "com.orbit.${project.name.replace("-", "_")}"
                    }
                }

                // Fix for "Incorrect package found in source AndroidManifest.xml"
                // This removes the 'package' attribute from the manifest in-memory/via-temp-file
                // to support modern AGP versions without modifying the Pub Cache.
                if (project.name == "flutter_windowmanager") {
                    val manifestFile = android.sourceSets.getByName("main").manifest.srcFile
                    if (manifestFile.exists()) {
                        val manifestContent = manifestFile.readText()
                        if (manifestContent.contains("package=")) {
                            val fixedManifestDir = File(project.projectDir, "build/intermediates/fixed_manifest")
                            fixedManifestDir.mkdirs()
                            val fixedManifestFile = File(fixedManifestDir, "AndroidManifest.xml")
                            val fixedContent = manifestContent.replace(Regex("""package\s*=\s*"[^"]*""""), "")
                            fixedManifestFile.writeText(fixedContent)
                            android.sourceSets.getByName("main").manifest.srcFile(fixedManifestFile)
                        }
                    }
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
