# Week 4 Project - Google Books App

Book searcher and reader iOS App using the Google Books API

## Build The Project

1. Clone or download the project
2. The project uses [CocoaPods]. Make sure you have it installed to install the dependencies.
3. Inside the project, execute:
```bash
pods install
```

## Run The Project

After installing Pod dependencies, open the file `GoogleBooks.xcworkspace` on Xcode

## Requirements

- [x] Inputs. Give the user a search box to enter the book to be searched (tableView screen)
- [x] Outputs. Make a visual grid of books with at least thumbnail, title, and author(s) displayed. Feel free to add addition meta data and information. 
- [ ] The user must be able to save his or her favorite books by double tapping a collection view cell – the favorites must also be shown in a grid.
- [ ] There must be a way to switch between “search mode” and “favorites mode”. 
- [x] You can use third party and open source libraries (within reason).
- [ ] Zip up the source and send it back to your trainer. Also, upload your code to Github (make an effort on the Readme file).
- [ ] The project must be simple to build. 
- [ ] The project must run on our side.
- [ ] The project should not crash. I shouldn’t get stuck somewhere (the flow should always work).
- [ ] Unit test bundle and unit test UI are required (not 100% is required).
- [x] Use at least 2 CocoaPods.
- [x] Use MVVM architecture design.
- [x] Each book always shows the correct associated image. 
- [ ] Utilize Core Data to persist favorited books
- One of the following (Bonus):
	- [ ] Create a screen within the app to accredit the CocoaPods used.
	- [ ] Some indicator on both the search list and/or grid and the favorites section, indicating that a book is favorited.
	- [x] Enable the user to search as they type into the search bar without pressing any search button.
	- [x] Ensure that each book always has the correct image associated to it.
	- [ ] Enable pagination.
	- [ ] Some other non-trivial feature.

[CocoaPods]: https://cocoapods.org/
