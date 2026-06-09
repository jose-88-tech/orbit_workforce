import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

// --- DATABASE HELPER ---
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  static const _storage = FlutterSecureStorage();
  static const _dbKeyName = 'db_encryption_key';

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> _getEncryptionKey() async {
    String? key = await _storage.read(key: _dbKeyName);
    if (key == null) {
      final random = Random.secure();
      final values = List<int>.generate(32, (i) => random.nextInt(256));
      key = base64Url.encode(values);
      await _storage.write(key: _dbKeyName, value: key);
    }
    return key;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'orbit_workforce.db');
    String password = await _getEncryptionKey();

    return await openDatabase(
      path,
      version: 1,
      password: password,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        password TEXT,
        full_name TEXT,
        role TEXT,
        org_name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE attendance_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        user_email TEXT,
        action_type TEXT,
        timestamp TEXT,
        method TEXT,
        site_location TEXT,
        selfie_url TEXT,
        location_status TEXT,
        is_on_time INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE sites (
        id TEXT PRIMARY KEY,
        site_name TEXT,
        site_code TEXT UNIQUE
      )
    ''');
    await db.insert('sites', {'id': '1', 'site_name': 'Site Office A', 'site_code': 'SITE-A-123'});
    await db.insert('sites', {'id': '2', 'site_name': 'Warehouse North', 'site_code': 'SITE-B-456'});
  }
}

// --- APP ENTRY POINT ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Orbit'),
              Text('Workforce Management Platform'),
              Text('Ready to scale your team?'),
            ],
          ),
        ),
      ),
    );
  }
}