<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url] -->



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/YiHanna/Team-9-Memory-Lane">
    <img src="logo.png" alt="Logo" width="80" height="80">
  </a>

  <h2 align="center">Memory Lane</h2>
</div>


<!-- ABOUT THE PROJECT -->
## About The Project
This is the project that Team 09 did for 67443 Mobile App Design and Development.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/YiHanna/Team-9-Memory-Lane.git
   ```
2. Go into MemoryLane folder in xcode
3. Run the project on a simulator or on a device

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Features
#### Account / User
- Register an account with email and fill out information including name, username, hometown, elementary school, middle school, high school, university, and current city
- Login into the account with email and password
- Users can view their profiles with basic information and a timeline of their memories (posts)
- Users can update their profiles and add a profile picture

#### Post
- View a list of posts made by all users
- Create posts with a description, date, location, and an optional photo
- Users can click on the “like/unlike” icon on a post and increase/decrease the number of likes for that post
- Comment on posts by clicking into the post and leaving comments
- Users can delete a post that they posted by going to their profile view and swiping left
- View Today’s Prompt (will be periodically updated based on holidays / special dates)
  - clickling on Today's Prompt will redirect users to the Add Post page with the prompt displayed for reference

#### Friends
- View a list of friends
- View a list of 5 recommended friends (recommendation determined by similarity with other users)
- Add/Remove friends
- View profile of other users with their information and memory lane

## App Infrastructure
Our app is primarily broken into the following components:
- Views (eg. LoginView, HomeView, FriendsView, ProfileView, etc.): These views dispaly our interface and data retrieved from firebase. They also support simle interactions such as liking a post, adding a friend, or editing a profile. 
- Models (User, Post, Prompt, Comment): Our firebase manages these four collections. Our models define the structure of the documents in these collections so it is easier to parse and manage.
- ViewModel, DBDocuments, and Helpers: These supports various functionalities in connection with the interface. 
  - ViewModel primarily handles the geolocation functionalities such as getting geo coordinates from addresses. It also supports fetching friend recommendations based on similarity calculations. 
  - DBDcouments primarily deals with functionalities that involve interactions with our database. It fetches data from firebase and store them into @Published variables to facilitate interactions. 
  - Helpers contains some general helper functions such as validating email & registration information and providing formatted times. 

<!-- LICENSE -->
## Testing

Most of our functionalities deal with firebase interactions, which we were told doesn't need to be tested. We considered testing some functions that only involve loaded firebase object arrays (eg. `users : [User]`). However, populating them with mock data is also challenging because we have attributes that were DocumentReferences, which can't be generated easily without connecting to firebase. 

Therefore, our testing is primarily focused on the ViewModel and the Helpers. For the ViewModel, we tested the coordniate conversions and the similarity score calculations. We weren't able to test `fetchRecs` because of the same reason above. For the Helpers, we tested all the functions listed. 

We were also told that UI Testing isn't needed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
