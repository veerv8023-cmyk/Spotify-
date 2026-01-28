# Spotify Advanced SQL Project and Query Optimization 
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT * FROM spotify
where stream >='1000000000'
```
2. List all albums along with their respective artists.
```sql
SELECT distinct(album),artist 
FROM spotify
order by 1
```

3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
SELECT SUM(comments) 
FROM spotify
where licensed = 'true'
```

4. Find all tracks that belong to the album type `single`.

```
SELECT * FROM spotify
WHERE album_type='single'
```
5. Count the total number of tracks by each artist.
```sql
SELECT 
		artist,
		count(track) 
FROM spotify
group by 1
```

### Medium Level

6. Calculate the average danceability of tracks in each album.
```
SELECT 
      DISTINCT(album),
	  avg(danceability)
FROM spotify
group by 1
```

7. Find the top 5 tracks with the highest energy values.
```
SELECT 
     distinct(track),
     max(energy) 
FROM spotify
group by 1
order by 2 desc
limit 5
```

8. List all tracks along with their views and likes where `official_video = TRUE`.
```
SELECT track,
      sum(views) as t_v,
	  sum(likes) as t_l
FROM spotify
where official_video = 'true'
group by 1
order by 2 desc
```

9. For each album, calculate the total views of all associated tracks.
```
SELECT album,
	  track,
	  sum(views)
FROM spotify
group by 1,2
order by 3 desc
```

10. Retrieve the track names that have been streamed on Spotify more than YouTube.
```
SELECT * FROM
(
SELECT 
     track,
     --most_played_on,
	 coalesce(sum(case when most_played_on='Youtube' then stream end),0) as s_on_youtube,
	 coalesce(sum(case when most_played_on='Spotify' then stream end),0) as s_on_spotify
FROM spotify
group by 1) as t
where  s_on_youtube < s_on_spotify and s_on_youtube <> 0
  ```
### Advanced Level
11. Find the top 3 most-viewed tracks for each artist using window functions.
```
with ranking_artist
as
(SELECT 
	artist,
	track,
	sum(views) as t_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY sum(views) desc) as rank
FROM spotify
group by 1,2
order by 1,3 desc)
select * from ranking_artist
where rank <=3
```
12. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT track,
      artist,
	  liveness
FROM spotify	 
where liveness > (select avg(liveness) from spotify)

```


13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
   
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```
SELECT track,
		energy/liveness as ratio 
FROM spotify
where energy/liveness >' 1.2'
```


15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
SELECT
distinct track,
	sum(likes) over(order by views desc) as cumulative_sum
FROM spotify
```

Here’s an updated section for your **Spotify Advanced SQL Project and Query Optimization** README, focusing on the query optimization task you performed. You can include the specific screenshots and graphs as described.

---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **7 ms**
        - Planning time (P.T.): **0.17 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
     
- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
  

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---

## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

---


