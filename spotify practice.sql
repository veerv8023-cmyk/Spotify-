- create table
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

--EDA

SELECT * FROM spotify;
SELECT count(*) FROM spotify
SELECT count(distinct artist) FROM spotify
SELECT count(distinct album) FROM spotify
SELECT distinct album_type FROM spotify
SELECT MAX(duration_min) FROM spotify
SELECT Min(duration_min) FROM spotify
SELECT distinct channel FROM spotify
SELECT distinct most_played_on FROM spotify

SELECT * FROM spotify
where duration_min='0'
delete FROM spotify
where duration_min='0'

-----------------------------------
---## 15 Practice Questions
------------------------------------

--1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
where stream >='1000000000'

--2. List all albums along with their respective artists.

SELECT distinct(album),artist 
FROM spotify
order by 1

--3. Get the total number of comments for tracks where `licensed = TRUE`.

SELECT SUM(comments) 
FROM spotify
where licensed = 'true'

--4. Find all tracks that belong to the album type `single`.

SELECT * FROM spotify
WHERE album_type='single'

--5. Count the total number of tracks by each artist.

SELECT 
		artist,
		count(track) 
FROM spotify
group by 1

--6. Calculate the average danceability of tracks in each album.

SELECT 
      DISTINCT(album),
	  avg(danceability)
FROM spotify
group by 1

--7. Find the top 5 tracks with the highest energy values.

SELECT 
     distinct(track),
     max(energy) 
FROM spotify
group by 1
order by 2 desc
limit 5

--8. List all tracks along with their views and likes where `official_video = TRUE`.
SELECT track,
      sum(views) as t_v,
	  sum(likes) as t_l
FROM spotify
where official_video = 'true'
group by 1
order by 2 desc

--9. For each album, calculate the total views of all associated tracks.

SELECT album,
	  track,
	  sum(views)
FROM spotify
group by 1,2
order by 3 desc

--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

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
     
--11. Find the top 3 most-viewed tracks for each artist using window functions.

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

--12. Write a query to find tracks where the liveness score is above the average.

SELECT track,
      artist,
	  liveness
FROM spotify	 
where liveness > (select avg(liveness) from spotify)



--13. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT track,
		energy/liveness as ratio 
FROM spotify
where energy/liveness >' 1.2'

--14. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
distinct track,
	sum(likes) over(order by views desc) as cumulative_sum
FROM spotify

/*15. **Use a `WITH` clause to calculate the difference between the highest and lowest energy
     values for tracks in each album.***/

with cte
as
(SELECT
	album,
	MAX(energy) as max_e,
	MIN(energy) as min_e
FROM spotify
group by 1
)
select album,max_e - min_e as diff_e 
from cte
order by 2 desc



	 