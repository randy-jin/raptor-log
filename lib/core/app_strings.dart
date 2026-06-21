import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;
  const AppStrings(this.locale);

  String get _lang => locale.languageCode;

  // ── Login ──────────────────────────────────────────────────────────────
  String get tagline1 => _s(
        en: 'Track every raptor you photograph.',
        zh: '记录每一只你拍到的猛禽。',
        fr: 'Documentez chaque rapace que vous photographiez.',
      );

  String get tagline2 => _s(
        en: 'Four levels. One obsession.',
        zh: '四个等级，一种执念。',
        fr: 'Quatre niveaux. Une obsession.',
      );

  String get emailLabel => _s(en: 'Email address', zh: '邮箱地址', fr: 'Adresse e-mail');

  String get sendMagicLink => _s(en: 'Send Magic Link', zh: '发送登录链接', fr: 'Envoyer le lien magique');

  String get checkEmailTitle => _s(en: '✉️ Check your email!', zh: '✉️ 请查看邮箱！', fr: '✉️ Vérifiez vos e-mails !');

  String checkEmailBody(String email) => _s(
        en: 'We sent a sign-in link to $email.\nTap the link to open the app.',
        zh: '我们已将登录链接发送至 $email。\n点击链接打开应用。',
        fr: 'Nous avons envoyé un lien à $email.\nAppuyez dessus pour ouvrir l\'app.',
      );

  String get useDifferentEmail => _s(en: 'Use a different email', zh: '使用其他邮箱', fr: 'Utiliser un autre e-mail');

  String get noPassword =>
      _s(en: 'No password needed. No credit card. Free forever.', zh: '无需密码，无需信用卡，永久免费。', fr: 'Sans mot de passe. Sans carte bancaire. Gratuit.');

  // ── Home ───────────────────────────────────────────────────────────────
  String get fieldJournal => _s(en: 'Field Journal', zh: '野外记录', fr: 'Carnet de terrain');

  String get achievementsTab => _s(en: 'Achievements', zh: '成就', fr: 'Succès');

  String get addSpecies => _s(en: 'Add species', zh: '添加物种', fr: 'Ajouter une espèce');

  String get signOut => _s(en: 'Sign Out', zh: '退出登录', fr: 'Se déconnecter');

  // ── Species list ───────────────────────────────────────────────────────
  String get searchSpecies => _s(en: 'Search species...', zh: '搜索物种...', fr: 'Rechercher une espèce...');

  String get allFamilies => _s(en: 'All families', zh: '全部科', fr: 'Toutes les familles');

  String get emptyTitle => _s(en: 'Your field journal is empty', zh: '野外记录本还是空的', fr: 'Votre carnet de terrain est vide');

  String get emptyBody => _s(
        en: 'Import the 36-species North American raptor starter list, or add your own.',
        zh: '导入36种北美猛禽入门列表，或自行添加。',
        fr: 'Importez la liste de 36 rapaces d\'Amérique du Nord, ou ajoutez les vôtres.',
      );

  String get importStarter => _s(en: 'Import 36 Starter Species', zh: '导入36种入门物种', fr: 'Importer 36 espèces de départ');

  String get addCustomSpecies => _s(en: 'Add Custom Species', zh: '添加自定义物种', fr: 'Ajouter une espèce personnalisée');

  // ── Stats ──────────────────────────────────────────────────────────────
  String get dashboardTitle => _s(en: 'Achievement Dashboard', zh: '成就仪表盘', fr: 'Tableau de bord');

  String get overallProgress => _s(en: 'Overall Progress', zh: '总体进度', fr: 'Progression globale');

  String ofSpecies(int count, int total) => _s(
        en: 'of $total species',
        zh: '共 $total 种',
        fr: 'sur $total espèces',
      );

  String get masterShots => _s(en: '数毛级 Master Shots', zh: '数毛级 精品大图', fr: '数毛级 Photos de maître');

  String get actionShots => _s(en: '飞行照 Action Shots', zh: '飞行照 飞行动作', fr: '飞行照 Photos en vol');

  // ── Achievement drawer ─────────────────────────────────────────────────
  String unlockTitle(String level) => _s(en: 'Unlock $level?', zh: '解锁$level？', fr: 'Débloquer $level ?');

  String get photoOptional => _s(
        en: 'You can optionally upload a proof photo next.',
        zh: '接下来可以选择上传一张证明照片。',
        fr: 'Vous pouvez ensuite télécharger une photo comme preuve.',
      );

  String get cancel => _s(en: 'Cancel', zh: '取消', fr: 'Annuler');

  String get unlock => _s(en: 'Unlock!', zh: '解锁！', fr: 'Débloquer !');

  String get removeAchievement => _s(en: 'Remove Achievement?', zh: '删除成就？', fr: 'Supprimer le succès ?');

  String removeBody(String level, String species) => _s(
        en: 'Remove the "$level" badge for $species?',
        zh: '删除 $species 的「$level」徽章？',
        fr: 'Supprimer le badge « $level » pour $species ?',
      );

  String get remove => _s(en: 'Remove', zh: '删除', fr: 'Supprimer');

  String unlockedOn(String date) => _s(en: 'Unlocked $date', zh: '解锁于 $date', fr: 'Débloqué le $date');

  // ── Add species ────────────────────────────────────────────────────────
  String get addSpeciesTitle => _s(en: 'Add Species', zh: '添加物种', fr: 'Ajouter une espèce');

  String get englishNameLabel => _s(en: 'English Name *', zh: '英文名 *', fr: 'Nom anglais *');

  String get chineseNameLabel => _s(en: 'Chinese Name (中文名)', zh: '中文名', fr: 'Nom chinois (中文名)');

  String get scientificNameLabel => _s(en: 'Scientific Name', zh: '学名', fr: 'Nom scientifique');

  String get scientificNameHint => _s(en: 'e.g. Accipiter gentilis', zh: '例：Accipiter gentilis', fr: 'ex. Accipiter gentilis');

  String get familyGroupLabel => _s(en: 'Family Group', zh: '科别', fr: 'Famille');

  String get selectFamily => _s(en: 'Select family', zh: '选择科别', fr: 'Choisir une famille');

  String get addToJournal => _s(en: 'Add to My Journal', zh: '添加到记录本', fr: 'Ajouter à mon carnet');

  String get required => _s(en: 'Required', zh: '必填', fr: 'Obligatoire');

  // ── Level names in French ──────────────────────────────────────────────
  // (used as supplement to kLevels which already has EN/ZH)
  String levelLabelFr(String levelKey) {
    const map = {
      'green': 'Observation',
      'blue': 'Portrait',
      'yellow': 'En vol',
      'red': 'Maître',
    };
    return map[levelKey] ?? levelKey;
  }

  String levelDescFr(String levelKey) {
    const map = {
      'green': 'N\'importe quelle photo montrant l\'oiseau',
      'blue': 'Portrait montrant les détails du plumage',
      'yellow': 'Photo en vol ou en action',
      'red': 'Netteté magazine avec détail des plumes',
    };
    return map[levelKey] ?? '';
  }

  // ── Helper ─────────────────────────────────────────────────────────────
  String _s({required String en, required String zh, required String fr}) {
    if (_lang == 'zh') return zh;
    if (_lang == 'fr') return fr;
    return en;
  }
}
