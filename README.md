# MangaMemo - Manga Reading Tracker App

⚠ Disclaimer: MangaMemo is a personal project. The application uses the MangaDex API, and users must ensure they have the necessary rights to read a work online.

MangaMemo is a Flutter-based mobile application designed to help users track and manage their manga reading progress. It allows users to search for mangas, view manga details, and store their favorites for quick access. The app leverages the MangaDex API to fetch manga data, such as titles, descriptions, cover images, and categories.

## Features
- **Search for Manga**: Users can search for manga by title and browse search results.
- **Manga Details**: View detailed information about each manga, including title, description, year of release, status, and cover image.
- **Favorites**: A feature to mark manga as favorites, allowing users to quickly access their favorite mangas. (Coming soon)
- **Chapter Progress**: Track which chapter the user has reached in each manga.
- **Latest Uploads**: View the latest uploaded mangas available to start reading.
  
## Categories
The app supports browsing mangas by categories, allowing users to discover new manga based on their interests. Some of the categories include:
- **Martial Arts**: Manga focused on martial arts themes, such as fighting, training, and discipline.
- **Full Color**: Manga that features vibrant full-color illustrations, making the reading experience more visually engaging.
- **Fantasy**: Manga that is set in a fantastical world, often with magic, mythical creatures, and adventurous storylines.
- **Latest**: View the latest uploaded manga to keep up with the newest releases in the manga world.

## Packages Used

### `http`
- The `http` package is used for making network requests to the MangaDex API to fetch manga details and cover images.

### `shared_preferences`
- The `shared_preferences` package is used for storing user preferences locally. This allows the app to save data like user favorites, last read chapters, and other settings across app sessions.

## API Integration
- The app integrates with the **MangaDex API** to fetch manga details and cover images.
