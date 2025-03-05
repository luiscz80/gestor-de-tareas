import 'package:tareas/models/categories.dart';
import 'package:tareas/models/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final _databaseName = "tareas.db";
  static final _databaseVersion = 1;

  static final tableTask = 'tasks';
  static final tableUser = 'users';
  static final tableCategory = 'categories';

  static final columnTaskId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnDate = 'date';
  static final columnPriority = 'priority';
  static final columnStatus = 'status';
  static final columnCategory = 'categoryId';

  static final columnUserId = 'id';
  static final columnName = 'name';
  static final columnCedula = 'cedula';
  static final columnAddress = 'address';
  static final columnCode = 'code';
  static final columnPhoneNumber = 'phoneNumber';
  static final columnSentAt = 'sentAt';

  static final columnCategoryId = 'id';
  static final columnCategoryName = 'name';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creating database version: $version");
    await db.execute('''
      CREATE TABLE $tableTask (
        $columnTaskId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnPriority TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnCategory INTEGER,
        
        FOREIGN KEY ($columnCategory) REFERENCES $tableCategory ($columnCategoryId)
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableUser (
        $columnUserId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnCedula TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnCode TEXT NOT NULL,
        $columnPhoneNumber TEXT NOT NULL,
        $columnSentAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableCategory (
        $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategoryName TEXT NOT NULL
      )
    ''');
    // Insertar default categories
    await insertDefaultCategories(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion");
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE ${tableTask}_temp (
          $columnTaskId INTEGER PRIMARY KEY,
          $columnTitle TEXT NOT NULL,
          $columnDescription TEXT NOT NULL,
          $columnCategory TEXT NOT NULL,
          $columnDate TEXT NOT NULL,
          $columnPriority TEXT NOT NULL,
          $columnStatus TEXT NOT NULL
          
        )
      ''');

      await db.execute('''
        INSERT INTO ${tableTask}_temp (
          $columnTaskId, $columnTitle, $columnDescription, $columnCategory, $columnDate, $columnPriority, $columnStatus
        )
        SELECT $columnTaskId, $columnTitle, $columnDescription, $columnCategory, $columnDate, $columnPriority, $columnStatus
        FROM $tableTask
      ''');

      await db.execute('DROP TABLE $tableTask');
      await db.execute('ALTER TABLE ${tableTask}_temp RENAME TO $tableTask');
    }
  }

  Future<void> insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {columnCategoryName: 'Otros'},
      {columnCategoryName: 'Urgente'},
      {columnCategoryName: 'Viajes'},
      {columnCategoryName: 'Social'},
      {columnCategoryName: 'Finanzas'},
      {columnCategoryName: 'Salud'},
      {columnCategoryName: 'Hogar'},
      {columnCategoryName: 'Estudio'},
      {columnCategoryName: 'Personal'},
      {columnCategoryName: 'Trabajo'},
    ];

    for (var category in defaultCategories) {
      await db.insert(
        tableCategory,
        category,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print('Categorías insertadas');
    }
  }

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    try {
      return await db.insert(tableTask, task.toMap());
    } catch (e) {
      print('Error al insertar tarea: $e');
      return -1;
    }
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    try {
      return await db.update(
        tableTask,
        task.toMap(),
        where: '$columnTaskId = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      print('Error al actualizar tarea: $e');
      return -1;
    }
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      tableTask,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete(tableTask);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableTask);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<List<Task>> getPendingTasks() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      where: '$columnStatus = ?',
      whereArgs: ['Pendiente'],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> updateTaskStatus(int taskId, String status) async {
    final db = await database;

    await db.update(
      tableTask,
      {columnStatus: status},
      where: '$columnTaskId = ?',
      whereArgs: [taskId],
    );
  }

  // Método para obtener los gastos semanales
  Future<List<Map<String, dynamic>>> getWeeklyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
      SELECT 
        strftime('%Y-%W', $columnDate) AS week,
        SUM($columnTaskId) AS total_amount
      FROM $tableTask
      GROUP BY week
      ORDER BY week DESC
    ''');
    } catch (e) {
      print('Error al consultar los gastos semanales: $e');
      return [];
    }
  }

  // Método para obtener los gastos mensuales
  Future<List<Map<String, dynamic>>> getMonthlyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
        SELECT 
          strftime('%Y-%m', $columnDate) AS month,
          SUM($columnTaskId) AS total_amount
        FROM $tableTask
        GROUP BY month
        ORDER BY month DESC
      ''');
    } catch (e) {
      print('Error al consultar los gastos mensuales: $e');
      return [];
    }
  }

  // Método para obtener los gastos anuales
  Future<List<Map<String, dynamic>>> getYearlyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
        SELECT 
          strftime('%Y', $columnDate) AS year,
          SUM($columnTaskId) AS total_amount
        FROM $tableTask
        GROUP BY year
        ORDER BY year DESC
      ''');
    } catch (e) {
      print('Error al consultar los gastos anuales: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDailyExpenses(DateTime date) async {
    Database db = await instance.database;
    try {
      // Formatear la fecha seleccionada en el formato de la base de datos (YYYY-MM-DD)
      String formattedDate =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      // Consulta para obtener los gastos de la fecha seleccionada
      return await db.query(
        tableTask,
        where: "$columnDate LIKE ?",
        whereArgs: ['$formattedDate%'],
        columns: [
          columnTaskId,
          columnTitle,
          columnDescription,
          columnDate,
          columnCategory
        ],
      );
    } catch (e) {
      print('Error al consultar los gastos diarios: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getTotalExpenseAmount() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM($columnTaskId) AS total_amount FROM $tableTask
    ''');
      return result.isNotEmpty ? result.first : {'total_amount': 0.0};
    } catch (e) {
      print('Error al obtener el monto total de los gastos: $e');
      return {'total_amount': 0.0};
    }
  }

  // Método para buscar gastos
  Future<List<Task>> searchExpenses(String query) async {
    final db = await database;
    var result = await db.rawQuery('''
      SELECT exp.*, cat.$columnCategoryName AS category_name
      FROM $tableTask as exp
      LEFT JOIN $tableCategory as cat ON exp.$columnCategory = cat.$columnCategoryId
      WHERE exp.$columnTitle LIKE ? OR exp.$columnTaskId LIKE ?
    ''', ['%$query%', '%$query%']);
    List<Task> expenses =
        result.isNotEmpty ? result.map((e) => Task.fromMap(e)).toList() : [];
    return expenses;
  }

  // Método para insertar user
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    try {
      print('Insertando usuario en la base de datos: ${user.toMap()}');
      int id = await db.insert(tableUser, user.toMap());
      print('Usuario insertado con ID: $id');
      return id;
    } catch (e) {
      print('Error al insertar datos de usuario: $e');
      return -1;
    }
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableUser);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Función para actualizar el PIN de seguridad
  Future<void> updatePin(int userId, String newPin) async {
    final db = await database;
    await db.update(
      tableUser,
      {columnCode: newPin},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> result = await db.query(tableUser);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  Future<String?> queryPin(String pin) async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        tableUser,
        where: '$columnCode = ?',
        whereArgs: [pin],
      );
      if (result.isNotEmpty) {
        return result.first[columnCode].toString();
      } else {
        return null;
      }
    } catch (e) {
      print('Error al verificar código: $e');
      return null;
    }
  }

  Future<void> updateVerificationCode(
      {required String phoneNumber, required String code}) async {
    final db = await instance.database;
    await db.update(
      tableUser,
      {columnCode: code},
      where: '$columnPhoneNumber = ?',
      whereArgs: [phoneNumber],
    );
  }

  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert(tableCategory, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update(
      tableCategory,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete(
      tableCategory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableCategory);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
}
