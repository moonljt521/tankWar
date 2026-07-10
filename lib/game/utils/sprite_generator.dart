import 'dart:math';
import 'dart:ui';
import '../data/constants.dart';

/// 程序化绘制经典 FC《坦克大战》风格的像素贴图。
/// 所有图均以 16 单元网格为基础，按 _u 像素/单元放大，再由上层缩放显示。
class SpriteGenerator {
  static final Map<String, Image> _cache = {};

  // 单元大小（越大越锐利，最终会缩放回显示尺寸）
  static const double _u = 4.0;
  // 通用描边色
  static const Color _ink = Color(0xFF1A1A1A);

  static Image _createImage(int w, int h, void Function(Canvas) draw) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    draw(canvas);
    final picture = recorder.endRecording();
    final img = picture.toImageSync(w, h);
    picture.dispose();
    return img;
  }

  // 以单元坐标绘制矩形像素块
  static void _px(Canvas c, double x, double y, double w, double h, Color color) {
    c.drawRect(
      Rect.fromLTWH(x * _u, y * _u, w * _u, h * _u),
      Paint()..color = color,
    );
  }

  // ====== 坦克 ======

  static Future<Image> getPlayerTank(Direction dir) async {
    final key = 'player_${dir.name}';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) {
      _rotate(c, dir, size, () => _drawTank(
        c,
        hull: const Color(0xFFE8C000),
        hullDark: const Color(0xFF9C7E00),
        hullLight: const Color(0xFFFFE45A),
        turret: const Color(0xFFFFE45A),
        turretDark: const Color(0xFFB8950A),
        tread: const Color(0xFF6E6E6E),
      ));
    });
    _cache[key] = img;
    return img;
  }

  static Future<Image> getEnemyTank(Direction dir, int type) async {
    final key = 'enemy_${dir.name}_$type';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final colors = _enemyPalette(type);
    final img = _createImage(size, size, (c) {
      _rotate(c, dir, size, () => _drawTank(
        c,
        hull: colors.hull,
        hullDark: colors.hullDark,
        hullLight: colors.hullLight,
        turret: colors.turret,
        turretDark: colors.turretDark,
        tread: colors.tread,
      ));
    });
    _cache[key] = img;
    return img;
  }

  static _EnemyColors _enemyPalette(int type) {
    switch (type) {
      case 1: // fast —— 深灰
        return const _EnemyColors(
          hull: Color(0xFF8A8A8A), hullDark: Color(0xFF454A45),
          hullLight: Color(0xFFB8B8B8), turret: Color(0xFFB0B0B0),
          turretDark: Color(0xFF505550), tread: Color(0xFF555A55),
        );
      case 2: // armor —— 绿
        return const _EnemyColors(
          hull: Color(0xFF4FA84F), hullDark: Color(0xFF226622),
          hullLight: Color(0xFF7BD07B), turret: Color(0xFF7BD07B),
          turretDark: Color(0xFF2A8A2A), tread: Color(0xFF454A45),
        );
      case 3: // heavy —— 棕红
        return const _EnemyColors(
          hull: Color(0xFFC26A3A), hullDark: Color(0xFF7A3A12),
          hullLight: Color(0xFFE89A5A), turret: Color(0xFFE89A5A),
          turretDark: Color(0xFF8A4A1A), tread: Color(0xFF554A4A),
        );
      default: // normal —— 灰白
        return const _EnemyColors(
          hull: Color(0xFFC0C0C0), hullDark: Color(0xFF787878),
          hullLight: Color(0xFFE8E8E8), turret: Color(0xFFE8E8E8),
          turretDark: Color(0xFF909090), tread: Color(0xFF606060),
        );
    }
  }

  // 旋转画布以适配朝向（坦克默认朝上绘制）
  static void _rotate(Canvas c, Direction dir, int size, void Function() draw) {
    c.save();
    switch (dir) {
      case Direction.up:
        break;
      case Direction.down:
        c.rotate(pi);
        c.translate(-size.toDouble(), -size.toDouble());
        break;
      case Direction.left:
        c.rotate(-pi / 2);
        c.translate(-size.toDouble(), 0);
        break;
      case Direction.right:
        c.rotate(pi / 2);
        c.translate(0, -size.toDouble());
        break;
    }
    draw();
    c.restore();
  }

  static void _drawTank(
    Canvas c, {
    required Color hull,
    required Color hullDark,
    required Color hullLight,
    required Color turret,
    required Color turretDark,
    required Color tread,
  }) {
    const treadDark = Color(0xFF262A2E);
    const treadLight = Color(0xFFA6B0B6);
    const barrel = Color(0xFF202226);
    const barrelEdge = Color(0xFF5A5E64);

    // —— 左履带 (cols 0-1, rows 0-15)
    _px(c, 0, 0, 2, 16, tread);
    _px(c, 0, 0, 1, 16, treadDark);                  // 外侧深色边
    for (int k = 0; k < 8; k++) {
      final r1 = (2 * k).toDouble();
      final r2 = (2 * k + 1).toDouble();
      _px(c, 1, r1, 1, 1, treadDark);                 // 履带节隔线
      _px(c, 1, r2, 1, 1, treadLight);               // 轮高光
      _px(c, 0, r2, 1, 1, tread);                     // 外缘下半亮
    }
    _px(c, 1, 15, 1, 1, treadDark);                  // 底边

    // —— 右履带 (cols 14-15)
    _px(c, 14, 0, 2, 16, tread);
    _px(c, 15, 0, 1, 16, treadDark);
    for (int k = 0; k < 8; k++) {
      final r1 = (2 * k).toDouble();
      final r2 = (2 * k + 1).toDouble();
      _px(c, 14, r1, 1, 1, treadDark);
      _px(c, 14, r2, 1, 1, treadLight);
      _px(c, 15, r2, 1, 1, tread);
    }
    _px(c, 14, 15, 1, 1, treadDark);

    // —— 车体 (cols 2-13, rows 4-14)
    _px(c, 2, 4, 12, 11, hull);
    _px(c, 3, 4, 10, 1, hullLight);                  // 前装甲斜面高光
    _px(c, 2, 5, 12, 1, hullDark);                   // 前缘分隔线
    _px(c, 2, 4, 1, 11, hullDark);                   // 左竖边
    _px(c, 13, 4, 1, 11, hullDark);                  // 右竖边
    _px(c, 2, 14, 12, 1, _ink);                      // 底部黑边
    _px(c, 2, 4, 1, 1, treadDark);                   // 前角斜切
    _px(c, 13, 4, 1, 1, treadDark);

    // —— 炮管 + 炮口制退器 (朝上 cols 6-9，rows 0-6)
    _px(c, 6, 0, 4, 1, _ink);                        // 炮口端面
    _px(c, 6, 1, 4, 1, barrel);                      // 炮口制退器（宽）
    _px(c, 7, 2, 2, 4, barrel);                      // 主炮管（2 宽，6 长）
    _px(c, 7, 2, 1, 4, barrelEdge);                  // 炮管左缘亮线
    _px(c, 6, 6, 4, 1, treadDark);                   // 炮根衔接炮塔

    // —— 炮塔 (cols 4-11, rows 7-12)
    _px(c, 4, 7, 8, 6, turret);
    _px(c, 4, 7, 8, 1, hullLight);                   // 顶部高光
    _px(c, 4, 12, 8, 1, turretDark);                 // 底部阴影
    _px(c, 4, 7, 1, 6, turretDark);                  // 左边
    _px(c, 11, 7, 1, 6, turretDark);                 // 右边
    _px(c, 4, 7, 1, 1, turretDark);                  // 圆角
    _px(c, 11, 7, 1, 1, turretDark);
    // 中心舱盖
    _px(c, 7, 9, 2, 2, turretDark);
    _px(c, 7, 9, 2, 1, hullLight);
    // 铆钉
    _px(c, 5, 8, 1, 1, turretDark);
    _px(c, 10, 8, 1, 1, turretDark);
    _px(c, 5, 11, 1, 1, turretDark);
    _px(c, 10, 11, 1, 1, turretDark);

    // —— 车体尾部细节 (row 13 中央) 区分前后
    _px(c, 6, 13, 1, 1, hullDark);
    _px(c, 9, 13, 1, 1, hullDark);
  }

  // ====== 子弹 ======

  static Future<Image> getBullet(Direction dir) async {
    final key = 'bullet_${dir.name}';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (8 * _u).toInt();
    final img = _createImage(size, size, (c) {
      _bulletPx(c, dir);
    });
    _cache[key] = img;
    return img;
  }

  static void _bulletPx(Canvas c, Direction dir) {
    const shell = Color(0xFFE8E8E8);
    const tip = Color(0xFFFFFFFF);
    const dark = Color(0xFF8A8A8A);
    // 在 8x8 网格内绘制一枚炮弹，朝上
    c.save();
    final size = (8 * _u).toDouble();
    switch (dir) {
      case Direction.up:
        break;
      case Direction.down:
        c.rotate(pi);
        c.translate(-size, -size);
        break;
      case Direction.left:
        c.rotate(-pi / 2);
        c.translate(-size, 0);
        break;
      case Direction.right:
        c.rotate(pi / 2);
        c.translate(0, -size);
        break;
    }
    _px(c, 3, 0, 2, 2, tip);     // 弹尖
    _px(c, 2, 2, 4, 4, shell);   // 弹身
    _px(c, 2, 2, 4, 1, dark);
    _px(c, 2, 5, 4, 1, dark);
    _px(c, 2, 2, 1, 4, dark);
    _px(c, 5, 2, 1, 4, dark);
    _px(c, 3, 3, 2, 2, tip);     // 中心亮点
    _px(c, 3, 6, 2, 2, dark);    // 尾翼
  }

  // ====== 砖墙 ======

  static Future<Image> getBrickWall() async {
    final key = 'brick';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) => _drawBrick(c));
    _cache[key] = img;
    return img;
  }

  static void _drawBrick(Canvas c) {
    const mortar = Color(0xFF3A2418);
    const brick = Color(0xFFB5482A);
    const brickLight = Color(0xFFD86848);
    const brickDark = Color(0xFF7C2A18);

    _px(c, 0, 0, 16, 16, mortar);
    // 错缝砖纹：8 单元砖，4 单元高
    for (int row = 0; row < 16; row++) {
      final inRow = (row ~/ 4) % 2; // 0 or 1
      for (int col = 0; col < 16; col++) {
        final localCol = col + (inRow == 1 ? 4 : 0);
        final isBrick = (localCol ~/ 8) % 2 == 0;
        if (isBrick && row % 4 != 3) {
          _px(c, col.toDouble(), row.toDouble(), 1, 1, brick);
          if (row % 4 == 0) _px(c, col.toDouble(), row.toDouble(), 1, 1, brickLight);
          if (row % 4 == 2) _px(c, col.toDouble(), row.toDouble(), 1, 1, brickDark);
        }
      }
    }
    // 加几条水平缝
    for (int r = 3; r < 16; r += 4) {
      _px(c, 0, r.toDouble(), 16, 1, mortar);
    }
  }

  // ====== 钢墙 ======

  static Future<Image> getSteelWall() async {
    final key = 'steel';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) => _drawSteel(c));
    _cache[key] = img;
    return img;
  }

  static void _drawSteel(Canvas c) {
    const steelDark = Color(0xFF4A5058);
    const steel = Color(0xFF90A0B0);
    const steelLight = Color(0xFFD4DEE8);
    const rivet = Color(0xFF2E323A);

    _px(c, 0, 0, 16, 16, steelDark);
    // 四块 8x8 钢板，带斜面高光
    for (int by = 0; by < 16; by += 8) {
      for (int bx = 0; bx < 16; bx += 8) {
        _px(c, bx + 1, by + 1, 7, 7, steel);
        _px(c, bx + 1, by + 1, 7, 1, steelLight); // 顶高光
        _px(c, bx + 1, by + 1, 1, 7, steelLight); // 左高光
        _px(c, bx + 7, by + 1, 1, 7, steelDark);  // 右阴影
        _px(c, bx + 1, by + 7, 7, 1, steelDark);  // 底阴影
        // 中心铆钉十字
        _px(c, bx + 4, by + 2, 1, 5, rivet);
        _px(c, bx + 2, by + 4, 5, 1, rivet);
        _px(c, bx + 4, by + 4, 1, 1, steelLight);
      }
    }
  }

  // ====== 水面（带波纹） ======

  static Future<Image> getWater() async {
    final key = 'water';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) {
      _animateWater(c, 0);
    });
    _cache[key] = img;
    return img;
  }

  static void _animateWater(Canvas c, int frame) {
    const deep = Color(0xFF0E2A6E);
    const mid = Color(0xFF2050A8);
    const light = Color(0xFF5C8AE0);
    _px(c, 0, 0, 16, 16, deep);
    for (int row = 0; row < 16; row += 4) {
      final off = ((row ~/ 4) % 2 + frame) % 2 * 2;
      _px(c, (off.toDouble()), row + 1, 8, 1, mid);
      _px(c, (off + 10) % 16, row + 1, 4, 1, mid);
      _px(c, (off + 2) % 16, row + 2, 4, 1, light);
      _px(c, (off + 8) % 16, row + 3, 6, 1, light);
    }
  }

  // ====== 森林（树木遮蔽） ======

  static Future<Image> getForest() async {
    final key = 'forest';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) => _drawForest(c));
    _cache[key] = img;
    return img;
  }

  static void _drawForest(Canvas c) {
    const ground = Color(0xFF1E5A1E);
    const trunk = Color(0xFF5A3A1A);
    const leafDark = Color(0xFF1A7A1A);
    const leaf = Color(0xFF2EA12E);
    const leafLight = Color(0xFF5FD05F);

    _px(c, 0, 0, 16, 16, ground);
    // 四棵树，错落排布
    final trees = [
      [2, 2], [9, 3], [3, 9], [10, 10],
    ];
    for (final t in trees) {
      final x = t[0].toDouble(), y = t[1].toDouble();
      _px(c, x + 1, y + 4, 2, 2, trunk);          // 树干
      _px(c, x, y, 4, 4, leafDark);                // 暗叶轮廓
      _px(c, x + 1, y + 1, 2, 2, leaf);            // 叶
      _px(c, x + 1, y, 2, 1, leafLight);          // 顶高光
      _px(c, x, y + 1, 1, 2, leafLight);
      _px(c, x + 3, y + 2, 1, 1, leafLight);
    }
  }

  // ====== 冰面 ======

  static Future<Image> getIce() async {
    final key = 'ice';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (16 * _u).toInt();
    final img = _createImage(size, size, (c) => _drawIce(c));
    _cache[key] = img;
    return img;
  }

  static void _drawIce(Canvas c) {
    const base = Color(0xFFB6D8E8);
    const shine = Color(0xFFEAF4FA);
    const crack = Color(0xFF88A8BE);
    const edge = Color(0xFF7AA0B8);

    _px(c, 0, 0, 16, 16, base);
    _px(c, 0, 0, 16, 1, shine);
    _px(c, 0, 15, 16, 1, edge);
    _px(c, 0, 0, 1, 16, shine);
    _px(c, 15, 0, 1, 16, edge);
    // 高光块
    _px(c, 2, 2, 4, 1, shine);
    _px(c, 9, 4, 3, 1, shine);
    _px(c, 3, 9, 5, 1, shine);
    _px(c, 10, 11, 3, 1, shine);
    // 冰裂纹
    _px(c, 3, 6, 1, 3, crack);
    _px(c, 4, 7, 1, 1, crack);
    _px(c, 10, 8, 1, 2, crack);
    _px(c, 11, 9, 2, 1, crack);
  }

  // ====== 基地（鹰徽） ======

  static Future<Image> getBase() async {
    final key = 'base';
    if (_cache.containsKey(key)) return _cache[key]!;
    final size = (32 * _u).toInt();
    final img = _createImage(size, size, (c) => _drawBase(c));
    _cache[key] = img;
    return img;
  }

  static void _drawBase(Canvas c) {
    const bg = Color(0xFF1A1A1A);
    const wall = Color(0xFF8A7A5A);
    const wallDark = Color(0xFF5A4A32);
    const eagle = Color(0xFFD8B040);
    const eagleDark = Color(0xFF8A6A1A);
    const beak = Color(0xFFE8D070);
    const eye = Color(0xFF1A1A1A);

    _px(c, 0, 0, 32, 32, bg);

    // 底座城墙
    final wallTop = 22.0;
    _px(c, 2, wallTop + 1, 28, 8, wall);
    _px(c, 2, wallTop + 1, 28, 1, Color(0xFFC0A878)); // 墙顶高光
    _px(c, 2, wallTop + 8, 28, 1, wallDark);          // 墙底阴影
    // 城垛（缺口）
    for (int i = 0; i < 28; i += 4) {
      final ix = (2 + i).toDouble();
      _px(c, ix, wallTop, 2, 2, wall);
      _px(c, ix, wallTop, 2, 1, const Color(0xFFC0A878));
    }

    // 鹰徽（朝上展开翅膀），以中心绘制
    const cx = 16.0; // 中心单元
    // 翅膀左
    _drawWing(c, cx, left: true, eagle: eagle, eagleDark: eagleDark);
    // 翅膀右
    _drawWing(c, cx, left: false, eagle: eagle, eagleDark: eagleDark);
    // 身体
    _px(c, cx - 2, 6, 4, 12, eagle);
    _px(c, cx - 2, 6, 4, 1, eagleDark);
    _px(c, cx - 2, 6, 1, 12, eagleDark);
    _px(c, cx + 1, 6, 1, 12, eagleDark);
    // 头
    _px(c, cx - 1, 3, 2, 3, eagle);
    _px(c, cx - 1, 3, 2, 1, eagleDark);
    _px(c, cx + 1, 4, 1, 1, beak); // 喙
    _px(c, cx - 1, 4, 1, 1, eye);  // 眼
    // 爪
    _px(c, cx - 2, 18, 1, 2, eagleDark);
    _px(c, cx + 1, 18, 1, 2, eagleDark);
  }

  static void _drawWing(Canvas c, double cx,
      {required bool left, required Color eagle, required Color eagleDark}) {
    // left: 向左延伸；right: 向右延伸。ox 为相对中心的偏移量
    double lx(double ox) => left ? (cx - ox - 1) : (cx + ox);
    _px(c, lx(4), 8, 4, 2, eagle);
    _px(c, lx(5), 7, 4, 2, eagle);
    _px(c, lx(7), 9, 4, 3, eagleDark);
    _px(c, lx(9), 11, 4, 2, eagle);
    _px(c, lx(12), 13, 2, 2, eagleDark);
    _px(c, lx(11), 15, 2, 2, eagle);
  }

  // ====== 缓存管理 ======

  static Future<void> generateAll() async {
    for (final dir in Direction.values) {
      await getPlayerTank(dir);
      for (int t = 0; t < 4; t++) {
        await getEnemyTank(dir, t);
      }
      await getBullet(dir);
    }
    await Future.wait([
      getBrickWall(),
      getSteelWall(),
      getWater(),
      getForest(),
      getIce(),
      getBase(),
    ]);
  }

  static void dispose() {
    for (final img in _cache.values) {
      img.dispose();
    }
    _cache.clear();
  }
}

class _EnemyColors {
  final Color hull, hullDark, hullLight, turret, turretDark, tread;
  const _EnemyColors({
    required this.hull,
    required this.hullDark,
    required this.hullLight,
    required this.turret,
    required this.turretDark,
    required this.tread,
  });
}