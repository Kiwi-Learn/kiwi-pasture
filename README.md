# kiwi-pasture

![Codeship Status for Kiwi-Learn/kiwi-pasture](https://codeship.com/projects/9de41700-8334-0133-a616-464b28b2a6d9/status?branch=master)

# API using example

**GET /**
- returns OK status to indicate service is alive
- tells us the current API version and Github homepage of API
- example:
```sh
# it will return the basic information of Kiwi farm
$ curl -GET http://kiwi-pasture.herokuapp.com/
KiwiPasture API v2 is up and running at <a href="api/v2">kiwi-pasture.herokuapp.com/api/v2</a>
```


**GET /api/v2/info/{course_id}.json**
- returns JSON of a single course info: id, name, url, date
- example:
```sh
# it will return the info of a single course
$ curl -GET http://kiwi-pasture.herokuapp.com/api/v2/info/MA02004.json
{"id":"MA02004","name":"會計學原理","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/352","date":"2014-10-27 - 2015-01-18"}
```


**GET /api/v2/courselist**
- returns JSON of all courses on ShareCourse
- example:
```sh
# it will return all courses on the Sharecourse
$ curl -GET http://kiwi-pasture.herokuapp.com/api/v2/courselist
[{"name":"背包客日語","date":"2015-12-07 - 2016-02-12","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/547",
"id":"JL85001"},
{"name":"超級英雄的物理學—從動漫畫及科幻電影學物理","date":"2016-01-01 - 2016-02-19","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/524",
"id":"PH81010"},
{"name":"楚漢相爭之職場競爭力","date":"2015-12-01 - 2016-01-26","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/525","id":"CM81009"},
...,
{"name":"小型風力機系統與國際認證 (104 秋季班)","date":"0000-00-00 - 0000-00-00","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/711","id":"EE62002"}]
```


**POST /api/v2/search**
- takes JSON: keyword we want to search
- returns Json of the most keyword-matched course info: id, name, url, date
- example:
```sh
# it will return the most keyword-matched course
$ curl -H "Content-Type: application/json" -X POST -d '{"keyword":"program"}' http://kiwi-pasture.herokuapp.com/api/v2/search
{"id":"CS01007","name":"計算機程式設計 C Programming","url":"http://www.sharecourse.net/sharecourse/course/view/courseInfo/25","date":"2013-09-16 - 2014-02-14"}
```


# For development

After clone this repository, use `bundle` to install all dependences

```sh
$ bundle install
```

Use `rackup` to run the web app, and visit [http://localhost:9292](http://localhost:9292/)

```sh
$ rackup
Thin web server (v1.6.4 codename Gob Bluth)
Maximum connections set to 1024
Listening on localhost:9292, CTRL+C to stop
```

Create table by Rakefile
```sh
rake db:migrate
```

Configure heroku ENV

```sh
rake config config_env:heroku RACK_ENV=production
```

Run testing

```sh
$ rake spec
```
