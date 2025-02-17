// CATEGORIES URLS
const String kLatestUploadsUrl = "https://api.mangadex.org/manga?order[latestUploadedChapter]=desc&limit=10";
const String kMartialArtsCategoryUrl = "https://api.mangadex.org/manga?includedTags[]=799c202e-7daa-44eb-9cf7-8a3c0441531e&limit=10";
const String kFantasyCategoryUrl = "https://api.mangadex.org/manga?includedTags[]=cdc58593-87dd-415e-bbc0-2ec27bf404cc&limit=10";
const String kAdventureCategoryUrl = "https://api.mangadex.org/manga?includedTags[]=87cc87cd-a395-47af-b27a-93258283bbc6&limit=10";
const String kFullColorCategoryUrl = "https://api.mangadex.org/manga?includedTags[]=f5ba408b-0e7a-484d-8d49-4e9125ac96de&limit=10";

// COVER ARTS URLS
const String kFilenameByMangaIdUrl = "https://api.mangadex.org/cover?manga[]="; // + MANGA ID
const String kMangaCoverUrl = "https://uploads.mangadex.org/covers/"; // + MANGA ID + / + FILENAME + .256.jpg

// MANGA MORE DETAILS URLS
const String kMangaByIdUrl = "https://api.mangadex.org/manga"; // + MANGA ID
const String kChaptersByMangaIdUrl = "https://api.mangadex.org/chapter?manga"; // + =MANGA ID

// READ MANGA URL
const String kReadChapterUrl = "https://api.mangadex.org/at-home/server"; // +  ChapterID

// SEARCH BY TITLE URL
const String kSearchMangaByTitleUrl = "http://api.mangadex.org/manga?title="; // + TITLE

// COLORS
const int kMainBgColor = 0xFF1E1E1E; // Fond principal (charcoal)
const int kBottomNavColor = 0xFF2C2C2C; // Fond de la bottom nav
const int kIconActiveColor = 0xFFFF7F3F; // Icônes actifs (orange ambré)
const int kIconInactiveColor = 0xFF5C6A72; // Icônes inactifs (gris bleuté)
const int kTitleColor = 0xFFFF7F3F; // Titres et en-têtes
const int kTextColor = 0xFFE0E0E0; // Texte principal
const int kTextSecondaryColor = 0xFFA0A0A0; // Texte secondaire
const int kWhiteColor = 0xFFFFFFFF; // Blanc
const int kAccentColor = 0xFFFF7F3F; // Boutons et éléments d'accentuation



