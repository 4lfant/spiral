// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dairo_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorDairoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DairoDatabaseBuilder databaseBuilder(String name) =>
      _$DairoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DairoDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$DairoDatabaseBuilder(null);
}

class _$DairoDatabaseBuilder {
  _$DairoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DairoDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DairoDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DairoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DairoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DairoDatabase extends DairoDatabase {
  _$DairoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  HubDao? _hubDaoInstance;

  PublicationDao? _publicationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` TEXT NOT NULL, `displayName` TEXT, `email` TEXT, `phoneNumber` TEXT, `photoURL` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `hub` (`id` TEXT NOT NULL, `userId` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `pictureUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `publication` (`id` TEXT NOT NULL, `hubId` TEXT NOT NULL, `text` TEXT, `mediaUrls` TEXT NOT NULL, `usersLiked` TEXT NOT NULL, `likesCount` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  HubDao get hubDao {
    return _hubDaoInstance ??= _$HubDao(database, changeListener);
  }

  @override
  PublicationDao get publicationDao {
    return _publicationDaoInstance ??=
        _$PublicationDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userItemDataInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (UserItemData item) => <String, Object?>{
                  'id': item.id,
                  'displayName': item.displayName,
                  'email': item.email,
                  'phoneNumber': item.phoneNumber,
                  'photoURL': item.photoURL
                },
            changeListener),
        _userItemDataDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['id'],
            (UserItemData item) => <String, Object?>{
                  'id': item.id,
                  'displayName': item.displayName,
                  'email': item.email,
                  'phoneNumber': item.phoneNumber,
                  'photoURL': item.photoURL
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserItemData> _userItemDataInsertionAdapter;

  final DeletionAdapter<UserItemData> _userItemDataDeletionAdapter;

  @override
  Stream<UserItemData?> getUserStream(String userId) {
    return _queryAdapter.queryStream('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserItemData(
            id: row['id'] as String,
            displayName: row['displayName'] as String?,
            email: row['email'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            photoURL: row['photoURL'] as String?),
        arguments: [userId],
        queryableName: 'user',
        isView: false);
  }

  @override
  Future<UserItemData?> getUser(String userId) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserItemData(
            id: row['id'] as String,
            displayName: row['displayName'] as String?,
            email: row['email'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            photoURL: row['photoURL'] as String?),
        arguments: [userId]);
  }

  @override
  Future<void> insertUser(UserItemData user) async {
    await _userItemDataInsertionAdapter.insert(
        user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(UserItemData user) async {
    await _userItemDataDeletionAdapter.delete(user);
  }
}

class _$HubDao extends HubDao {
  _$HubDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _hubItemDataInsertionAdapter = InsertionAdapter(
            database,
            'hub',
            (HubItemData item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'name': item.name,
                  'description': item.description,
                  'pictureUrl': item.pictureUrl
                },
            changeListener),
        _hubItemDataDeletionAdapter = DeletionAdapter(
            database,
            'hub',
            ['id'],
            (HubItemData item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'name': item.name,
                  'description': item.description,
                  'pictureUrl': item.pictureUrl
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HubItemData> _hubItemDataInsertionAdapter;

  final DeletionAdapter<HubItemData> _hubItemDataDeletionAdapter;

  @override
  Stream<List<HubItemData>> getUserHubsStream(String userId) {
    return _queryAdapter.queryListStream('SELECT * FROM hub WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => HubItemData(
            id: row['id'] as String,
            userId: row['userId'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            pictureUrl: row['pictureUrl'] as String),
        arguments: [userId],
        queryableName: 'hub',
        isView: false);
  }

  @override
  Future<void> insertHub(HubItemData hub) async {
    await _hubItemDataInsertionAdapter.insert(hub, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertHubs(List<HubItemData> hubs) async {
    await _hubItemDataInsertionAdapter.insertList(
        hubs, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteHub(HubItemData hub) async {
    await _hubItemDataDeletionAdapter.delete(hub);
  }
}

class _$PublicationDao extends PublicationDao {
  _$PublicationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _publicationItemDataInsertionAdapter = InsertionAdapter(
            database,
            'publication',
            (PublicationItemData item) => <String, Object?>{
                  'id': item.id,
                  'hubId': item.hubId,
                  'text': item.text,
                  'mediaUrls': item.mediaUrls,
                  'usersLiked': item.usersLiked,
                  'likesCount': item.likesCount
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PublicationItemData>
      _publicationItemDataInsertionAdapter;

  @override
  Stream<List<PublicationItemData>> getHubPublicationsStream(String hubId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM publication WHERE hubId = ?1',
        mapper: (Map<String, Object?> row) => PublicationItemData(
            id: row['id'] as String,
            hubId: row['hubId'] as String,
            text: row['text'] as String?,
            mediaUrls: row['mediaUrls'] as String,
            usersLiked: row['usersLiked'] as String,
            likesCount: row['likesCount'] as int),
        arguments: [hubId],
        queryableName: 'publication',
        isView: false);
  }

  @override
  Future<void> insertPublication(PublicationItemData publication) async {
    await _publicationItemDataInsertionAdapter.insert(
        publication, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPublications(
      List<PublicationItemData> publications) async {
    await _publicationItemDataInsertionAdapter.insertList(
        publications, OnConflictStrategy.replace);
  }
}
