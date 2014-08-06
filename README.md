# MFADT Bootcamp 2013 Visualization
MFADT, Parsons The New School for Design

Visualizing all posts from the [MFADT Bootcamp 2013 blog](http://bootcamp.parsons.edu/2013/)

Data Scraped with [Kimono](https://www.kimonolabs.com/)

August, 2014

---

## Data
**1. Acquire**

  * Scraped data from the [Bootcamp 2013 website](http://bootcamp.parsons.edu/2013/) using [Kimono](https://www.kimonolabs.com/):
    * post + href
    * student
    * tags
    * date
  * Scraped data from the [people page](http://bootcamp.parsons.edu/2013/people), to get a list of students and teams
    
**2. Parse**

  * Converted from csv to tsv using [Google Spreadsheets](https://docs.google.com/spreadsheets)
  	* File > Import > Upload
  	* File > Download as > Tab-separated values
  	
**3. Filter**

  * Using step_01_dataToObjects:
    * Filtered out tags and left only classes (Code, Design, Web, and Uncategorized)
    * Crossing data with the students list, assigned teams to each student
    * Assigned "faculty" to teachers
    * Stored post data into objects