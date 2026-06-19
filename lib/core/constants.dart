import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// Achievement Level Definitions
// ─────────────────────────────────────────

enum AchievementLevel { green, blue, yellow, red }

class LevelInfo {
  final AchievementLevel level;
  final String key;
  final String labelEn;
  final String labelZh;
  final String descriptionEn;
  final String descriptionZh;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final IconData icon;

  const LevelInfo({
    required this.level,
    required this.key,
    required this.labelEn,
    required this.labelZh,
    required this.descriptionEn,
    required this.descriptionZh,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.icon,
  });
}

const List<LevelInfo> kLevels = [
  LevelInfo(
    level: AchievementLevel.green,
    key: 'green',
    labelEn: 'Recorded',
    labelZh: '已记录',
    descriptionEn: 'Photographed — silhouette or proof of presence',
    descriptionZh: '拍到轮廓，证明该物种存在即可',
    color: Color(0xFF2E7D32),
    bgColor: Color(0xFFE8F5E9),
    borderColor: Color(0xFF66BB6A),
    icon: Icons.check_circle_outline,
  ),
  LevelInfo(
    level: AchievementLevel.blue,
    key: 'blue',
    labelEn: 'Clear Shot',
    labelZh: '清晰照',
    descriptionEn: 'Good light, sharp focus, details visible',
    descriptionZh: '光线到位，对焦精准，细节清晰',
    color: Color(0xFF1565C0),
    bgColor: Color(0xFFE3F2FD),
    borderColor: Color(0xFF42A5F5),
    icon: Icons.photo_camera,
  ),
  LevelInfo(
    level: AchievementLevel.yellow,
    key: 'yellow',
    labelEn: 'Action Shot',
    labelZh: '飞行照',
    descriptionEn: 'Wings spread, gliding, or dive-hunting captured',
    descriptionZh: '成功捕捉振翅、滑翔或砸水捕食动态瞬间',
    color: Color(0xFFF57F17),
    bgColor: Color(0xFFFFF8E1),
    borderColor: Color(0xFFFFCA28),
    icon: Icons.flight,
  ),
  LevelInfo(
    level: AchievementLevel.red,
    key: 'red',
    labelEn: 'Master Shot',
    labelZh: '数毛级',
    descriptionEn: 'Eye-light, feather texture, perfect exposure — flawless',
    descriptionZh: '眼神光、羽毛纹路、高光控制全方位无懈可击',
    color: Color(0xFFC62828),
    bgColor: Color(0xFFFFEBEE),
    borderColor: Color(0xFFEF5350),
    icon: Icons.star,
  ),
];

LevelInfo levelInfo(AchievementLevel level) =>
    kLevels.firstWhere((l) => l.level == level);

LevelInfo levelInfoByKey(String key) =>
    kLevels.firstWhere((l) => l.key == key);

// ─────────────────────────────────────────
// Starter Species List (36 North American Raptors)
// ─────────────────────────────────────────

class SpeciesSeed {
  final String commonName;
  final String chineseName;
  final String scientificName;
  final String familyGroup;
  final String descriptionEn;
  final String descriptionZh;
  final int sortOrder;

  const SpeciesSeed({
    required this.commonName,
    required this.chineseName,
    required this.scientificName,
    required this.familyGroup,
    required this.descriptionEn,
    required this.descriptionZh,
    required this.sortOrder,
  });
}

const List<SpeciesSeed> kStarterSpecies = [
  // ── Eagles (雕家族) ──
  SpeciesSeed(
    commonName: 'Bald Eagle',
    chineseName: '白头海雕',
    scientificName: 'Haliaeetus leucocephalus',
    familyGroup: 'Eagles',
    descriptionEn: 'Iconic NA symbol, 2m wingspan, frequently steals fish around dams.',
    descriptionZh: '北美特有标志，翼展2米，常在河流大坝抢鱼。',
    sortOrder: 10,
  ),
  SpeciesSeed(
    commonName: 'Golden Eagle',
    chineseName: '金雕',
    scientificName: 'Aquila chrysaetos',
    familyGroup: 'Eagles',
    descriptionEn: 'Ruler of the Rockies, top-tier power, capable of hunting mountain goats.',
    descriptionZh: '落基山峡谷霸主，力量天花板，能单杀山羊。',
    sortOrder: 11,
  ),
  // ── Hawks / Buteos (鸢家族) ──
  SpeciesSeed(
    commonName: 'Red-tailed Hawk',
    chineseName: '红尾鸢',
    scientificName: 'Buteo jamaicensis',
    familyGroup: 'Hawks',
    descriptionEn: 'Most common NA hawk, highly territorial, loves high tree tops.',
    descriptionZh: '北美数量第一，领地意识极强，喜停高大树顶。',
    sortOrder: 20,
  ),
  SpeciesSeed(
    commonName: "Swainson's Hawk",
    chineseName: '斯氏鸢',
    scientificName: 'Buteo swainsoni',
    familyGroup: 'Hawks',
    descriptionEn: 'Summer star of Alberta plains, long-distance migrator, loves catching grasshoppers on the ground.',
    descriptionZh: '阿省平原夏日主角，长途迁徙，酷爱在地上抓蚂蚱。',
    sortOrder: 21,
  ),
  SpeciesSeed(
    commonName: 'Ferruginous Hawk',
    chineseName: '王鸢',
    scientificName: 'Buteo regalis',
    familyGroup: 'Hawks',
    descriptionEn: 'Largest NA hawk, huge gape, approaches eagles in size and power.',
    descriptionZh: '北美最大的鸢，嘴裂极大，体型和战力逼近雕类。',
    sortOrder: 22,
  ),
  SpeciesSeed(
    commonName: 'Rough-legged Hawk',
    chineseName: '毛足鸢',
    scientificName: 'Buteo lagopus',
    familyGroup: 'Hawks',
    descriptionEn: 'Arctic winter visitor, fully feathered legs, common in winter fields.',
    descriptionZh: '北极圈过冬客，全腿长毛，冬季农田常见。',
    sortOrder: 23,
  ),
  SpeciesSeed(
    commonName: 'Broad-winged Hawk',
    chineseName: '阔翅鸢',
    scientificName: 'Buteo platypterus',
    familyGroup: 'Hawks',
    descriptionEn: 'Miniature Buteo, mainly found in eastern forests.',
    descriptionZh: '鸢家族里的迷你成员，主要活动于东部森林。',
    sortOrder: 24,
  ),
  // ── Accipiters (鹰刺客) ──
  SpeciesSeed(
    commonName: 'Northern Goshawk',
    chineseName: '苍鹰',
    scientificName: 'Accipiter gentilis',
    familyGroup: 'Accipiters',
    descriptionEn: 'Blood-red eyes, largest and most ferocious apex predator in dense forests.',
    descriptionZh: '眼神血红，林区体型最大、最凶悍的冷酷刺客。',
    sortOrder: 30,
  ),
  SpeciesSeed(
    commonName: "Cooper's Hawk",
    chineseName: '库氏鹰',
    scientificName: 'Accipiter cooperii',
    familyGroup: 'Accipiters',
    descriptionEn: 'Long-tailed forest hawk, frequently ambushes small birds near backyard feeders.',
    descriptionZh: '尾巴极长，常在人类后院鸟类喂食器旁偷袭小鸟。',
    sortOrder: 31,
  ),
  SpeciesSeed(
    commonName: 'Sharp-shinned Hawk',
    chineseName: '条纹鹰',
    scientificName: 'Accipiter striatus',
    familyGroup: 'Accipiters',
    descriptionEn: 'Smallest NA accipiter, very similar in appearance to Cooper\'s Hawk.',
    descriptionZh: '该属体型最小者，与库氏鹰极其神似。',
    sortOrder: 32,
  ),
  // ── Harriers (鹞家族) ──
  SpeciesSeed(
    commonName: 'Northern Harrier',
    chineseName: '灰泽鹞',
    scientificName: 'Circus hudsonius',
    familyGroup: 'Harriers',
    descriptionEn: "North America's only harrier, owl-like facial disc, glides low using sound.",
    descriptionZh: '北美独苗，面盘神似猫头鹰，靠听觉贴地滑翔。',
    sortOrder: 40,
  ),
  // ── Kites (鸢科) ──
  SpeciesSeed(
    commonName: 'White-tailed Kite',
    chineseName: '白尾鸢',
    scientificName: 'Elanus leucurus',
    familyGroup: 'Kites',
    descriptionEn: 'Red eyes, white body, black shoulders; master of hovering, stunning appearance.',
    descriptionZh: '红眼白身黑肩膀，精通高频悬停，高颜值代表。',
    sortOrder: 50,
  ),
  SpeciesSeed(
    commonName: 'Swallow-tailed Kite',
    chineseName: '燕尾鸢',
    scientificName: 'Elanoides forficatus',
    familyGroup: 'Kites',
    descriptionEn: 'Deeply forked tail, striking black-and-white, most graceful flight in NA.',
    descriptionZh: '尾巴分叉如巨燕，黑白分明，北美飞姿最优雅。',
    sortOrder: 51,
  ),
  SpeciesSeed(
    commonName: 'Mississippi Kite',
    chineseName: '密西西比鸢',
    scientificName: 'Ictinia mississippiensis',
    familyGroup: 'Kites',
    descriptionEn: 'Small and agile, performs aerial acrobatics to catch large insects mid-air.',
    descriptionZh: '体型小巧，擅长在空中表演杂技并截杀大型昆虫。',
    sortOrder: 52,
  ),
  SpeciesSeed(
    commonName: 'Snail Kite',
    chineseName: '螺鸢',
    scientificName: 'Rostrhamus sociabilis',
    familyGroup: 'Kites',
    descriptionEn: 'Slender curved beak, extreme specialist, feeds exclusively on apple snails in Florida.',
    descriptionZh: '细长弯钩嘴，极端偏食，一辈子只在佛州沼泽吃福寿螺。',
    sortOrder: 53,
  ),
  // ── Falcons (隼家族) ──
  SpeciesSeed(
    commonName: 'American Kestrel',
    chineseName: '美洲隼',
    scientificName: 'Falco sparverius',
    familyGroup: 'Falcons',
    descriptionEn: 'Smallest diurnal raptor in NA (dove-sized), colorful blue-red plumage, hovers over fences.',
    descriptionZh: '北美白天最小猛禽（鸽子大），蓝红炫彩，擅长铁丝网悬停。',
    sortOrder: 60,
  ),
  SpeciesSeed(
    commonName: 'Peregrine Falcon',
    chineseName: '游隼',
    scientificName: 'Falco peregrinus',
    familyGroup: 'Falcons',
    descriptionEn: 'King of speed, dives at over 320 km/h, ultimate urban pigeon hunter.',
    descriptionZh: '速度之王，高空俯冲时速破320公里，城市鸽子克星。',
    sortOrder: 61,
  ),
  SpeciesSeed(
    commonName: 'Prairie Falcon',
    chineseName: '草原隼',
    scientificName: 'Falco mexicanus',
    familyGroup: 'Falcons',
    descriptionEn: 'Desert falcon, highly aggressive, openly clashes with golden eagles on the plains.',
    descriptionZh: '荒漠大隼，脾气暴躁，敢在大平原与金雕正面迎击。',
    sortOrder: 62,
  ),
  SpeciesSeed(
    commonName: 'Gyrfalcon',
    chineseName: '矛隼',
    scientificName: 'Falco rusticolus',
    familyGroup: 'Falcons',
    descriptionEn: "World's largest falcon, prize of the Arctic, ranges from dark gray to pure white.",
    descriptionZh: '全世界最大的隼，北极圈极品，暗灰或纯白羽色。',
    sortOrder: 63,
  ),
  SpeciesSeed(
    commonName: 'Merlin',
    chineseName: '灰背隼',
    scientificName: 'Falco columbarius',
    familyGroup: 'Falcons',
    descriptionEn: 'Powerful mini-falcon, incredibly fast, specializes in relentless level-flight chases.',
    descriptionZh: '「小黑侠」，体型小速度极快，擅长在空中直线生猛硬追。',
    sortOrder: 64,
  ),
  SpeciesSeed(
    commonName: 'Crested Caracara',
    chineseName: '凤头卡拉鹰',
    scientificName: 'Caracara plancus',
    familyGroup: 'Falcons',
    descriptionEn: 'Maverick of the falcon family, long legs, walks on roadsides scavenging with vultures.',
    descriptionZh: '隼家叛徒，大长腿，经常在路边步行和秃鹫一起捡腐肉。',
    sortOrder: 65,
  ),
  // ── Osprey (鹗家族) ──
  SpeciesSeed(
    commonName: 'Osprey',
    chineseName: '鹗（鱼鹰）',
    scientificName: 'Pandion haliaetus',
    familyGroup: 'Ospreys',
    descriptionEn: 'Solo family, hovers stationary, calculates water refraction, dives feet-first for fish.',
    descriptionZh: '独门独户，高空悬停定格，精准计算折射，砸水暴力抓鱼。',
    sortOrder: 70,
  ),
  // ── New World Vultures (美洲鹫) ──
  SpeciesSeed(
    commonName: 'California Condor',
    chineseName: '加州神鹰',
    scientificName: 'Gymnogyps californianus',
    familyGroup: 'Vultures',
    descriptionEn: 'Largest NA land bird, 3m wingspan, critically endangered bald scavenger.',
    descriptionZh: '北美最大白天陆地鸟皇，3米翼展，极度濒危的光头清道夫。',
    sortOrder: 80,
  ),
  SpeciesSeed(
    commonName: 'Turkey Vulture',
    chineseName: '红头美洲鹫',
    scientificName: 'Cathartes aura',
    familyGroup: 'Vultures',
    descriptionEn: 'Bald red head, flies with a distinct V-shape dihedral, highly common across NA.',
    descriptionZh: '红色秃头，高空张开双翼呈标志性"V"字形，全北美极常见。',
    sortOrder: 81,
  ),
  SpeciesSeed(
    commonName: 'Black Vulture',
    chineseName: '黑美洲鹫',
    scientificName: 'Coragyps atratus',
    familyGroup: 'Vultures',
    descriptionEn: 'Black-gray bald head, ranges further south than the Turkey Vulture.',
    descriptionZh: '头部黑灰色，比红头美洲鹫分布更靠南方。',
    sortOrder: 82,
  ),
  // ── Barn Owls (草鸮科) ──
  SpeciesSeed(
    commonName: 'Barn Owl',
    chineseName: '仓鸮',
    scientificName: 'Tyto alba',
    familyGroup: 'Barn Owls',
    descriptionEn: 'Classic heart-shaped "monkey face", widespread barn-dwelling rodent hunter.',
    descriptionZh: '经典"心形猴子脸"，全北美分布极广的农舍守护神。',
    sortOrder: 90,
  ),
  // ── True Owls (鸱鸮科) ──
  SpeciesSeed(
    commonName: 'Great Horned Owl',
    chineseName: '大角鸮',
    scientificName: 'Bubo virginianus',
    familyGroup: 'True Owls',
    descriptionEn: 'All-around apex predator, prominent ear tufts, 1.4m wingspan.',
    descriptionZh: '卡城全能战神，顶着假角羽，深夜翼展近一米四。',
    sortOrder: 100,
  ),
  SpeciesSeed(
    commonName: 'Snowy Owl',
    chineseName: '雪鸮',
    scientificName: 'Bubo scandiacus',
    familyGroup: 'True Owls',
    descriptionEn: 'Heaviest NA owl, pure white Arctic native, migrates south in winter.',
    descriptionZh: '北美最重猫头鹰，北极纯白冰原客，冬季南迁。',
    sortOrder: 101,
  ),
  SpeciesSeed(
    commonName: 'Great Gray Owl',
    chineseName: '乌林鸮',
    scientificName: 'Strix nebulosa',
    familyGroup: 'True Owls',
    descriptionEn: 'Tallest NA owl (nearly 1m), massive facial disc, mostly fluff and feathers.',
    descriptionZh: '北美身高之王（近1米），头盘巨大，纯靠羽毛虚胖。',
    sortOrder: 102,
  ),
  SpeciesSeed(
    commonName: 'Barred Owl',
    chineseName: '横斑鸮',
    scientificName: 'Strix varia',
    familyGroup: 'True Owls',
    descriptionEn: 'Large dark eyes, distinct rhythmic hooting, prefers dense, wet forests.',
    descriptionZh: '黑色大眼睛，叫声神似人语，主要栖息于湿润森林。',
    sortOrder: 103,
  ),
  SpeciesSeed(
    commonName: 'Long-eared Owl',
    chineseName: '长耳鸮',
    scientificName: 'Asio otus',
    familyGroup: 'True Owls',
    descriptionEn: 'Long ear tufts, masters of daytime camouflage against tree bark.',
    descriptionZh: '拥有极长耳羽，白天在树干丛中死死伪装成树皮。',
    sortOrder: 104,
  ),
  SpeciesSeed(
    commonName: 'Short-eared Owl',
    chineseName: '短耳鸮',
    scientificName: 'Asio flammeus',
    familyGroup: 'True Owls',
    descriptionEn: 'Tiny ear tufts, cat-like face, frequently hunts over open marshes by day.',
    descriptionZh: '耳羽极短，长得像猫，白天也常在大草甸低空飞翔。',
    sortOrder: 105,
  ),
  SpeciesSeed(
    commonName: 'Northern Hawk Owl',
    chineseName: '猛鸮',
    scientificName: 'Surnia ulula',
    familyGroup: 'True Owls',
    descriptionEn: 'Looks and behaves like a diurnal hawk, hunts from high perches in the north.',
    descriptionZh: '行为和长相极其接近白天老鹰的北境奇特猫头鹰。',
    sortOrder: 106,
  ),
  SpeciesSeed(
    commonName: 'Northern Saw-whet Owl',
    chineseName: '棕榈鬼鸮',
    scientificName: 'Aegolius acadicus',
    familyGroup: 'True Owls',
    descriptionEn: 'Tiny local favorite (palm-sized), hides deep in dense thickets by day.',
    descriptionZh: '卡城本地最小萌神（巴掌大），白天躲在茂密灌木丛。',
    sortOrder: 107,
  ),
  SpeciesSeed(
    commonName: 'Elf Owl',
    chineseName: '姬鸮',
    scientificName: 'Micrathene whitneyi',
    familyGroup: 'True Owls',
    descriptionEn: "World's smallest owl (40g), nests exclusively in desert cactus holes.",
    descriptionZh: '全世界最小的猫头鹰（40克），生活在南部沙漠仙人掌洞。',
    sortOrder: 108,
  ),
  SpeciesSeed(
    commonName: 'Burrowing Owl',
    chineseName: '穴鸮',
    scientificName: 'Athene cunicularia',
    familyGroup: 'True Owls',
    descriptionEn: 'Long-legged, lives underground in abandoned prairie dog burrows, highly expressive.',
    descriptionZh: '大长腿，喜欢住在土拨鼠废弃的地洞里，动作极其搞笑。',
    sortOrder: 109,
  ),
];

// Family display order
const List<String> kFamilyOrder = [
  'Eagles',
  'Hawks',
  'Accipiters',
  'Harriers',
  'Kites',
  'Falcons',
  'Ospreys',
  'Vultures',
  'Barn Owls',
  'True Owls',
];

const Map<String, String> kFamilyChineseNames = {
  'Eagles': '雕家族',
  'Hawks': '鸢家族',
  'Accipiters': '鹰刺客',
  'Harriers': '鹞家族',
  'Kites': '鸢科',
  'Falcons': '隼家族',
  'Ospreys': '鹗家族',
  'Vultures': '美洲鹫',
  'Barn Owls': '草鸮科',
  'True Owls': '鸱鸮科',
};
