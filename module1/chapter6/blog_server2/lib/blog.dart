library blog_entities;

import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';
import 'package:watcher/watcher.dart';

/// Class for a blog website
class Blog {
  final String _pathPosts;
  final String _pathImgs;

  String _pathDefaultImg;
  List<int> IDs;
  Map<int, String> postPaths;
  Map<int, String> imgPaths;
  Map _cache;
  DirectoryWatcher _changeMonitor;

  Blog(this._pathPosts, this._pathImgs) {
    _changeMonitor = DirectoryWatcher(this._pathPosts);
    _changeMonitor.events.listen((watchEvent) => initBlog());
  }

  initBlog() async {
    _cache = {};
    IDs = List<int>();
    postPaths = Map<int, String>();
    imgPaths = Map<int, String>();
    await _loadPostList();
    _loadImgList();
  }

  // Load posts for the blog to aid serving.
  _loadPostList() async {
    print('Loading from $_pathPosts');
    Directory blogContent = Directory(_pathPosts);

    // Load up all the blog posts do get a list of IDs.
    var postsSrc = blogContent.listSync();

    for (File f in postsSrc) {
      String postFilename = path.basenameWithoutExtension(f.path);
      int id = int.parse(postFilename);
      IDs.add(id);
      postPaths[id] = f.path;
    }

    IDs.sort();
    IDs = IDs.reversed.toList();
  }

  // Load posts for the img to aid serving.
  void _loadImgList() {
    print('Loading from $_pathImgs');
    Directory imgContent = Directory(_pathImgs);

    // Load up all the blog posts do get a list of IDs.
    imgContent.list().forEach((f) {
      String imgFileName = path.basename(f.path).replaceAll('.png', '');
      if (imgFileName != 'default') {
        int id = int.parse(imgFileName);
        imgPaths[id] = f.path;
      } else {
        _pathDefaultImg = f.path;
      }
    });
  }

  // Build a single post the blog.
  BlogPost getBlogPost(int index) {
    if (!_cache.containsKey(index)) {
      _cache[index] = BlogPost(postPaths[index], index);
    }
    return _cache[index];
  }

  // Build a single post the blog.
  File getBlogImage(int index) {
    String path;
    if (imgPaths.containsKey(index)) {
      path = imgPaths[index];
    } else {
      path = _pathDefaultImg;
    }
    return File(path);
  }

  // Build the front page of the blog
  String getFrontPage() {
    String frontPage = '';

    IDs.sublist(0, min(5, IDs.length)).forEach((int postId) {
      BlogPost post = getBlogPost(postId);
      frontPage += post.HTML + '<hr/>';
    });

    return frontPage;
  }

  // Get the next blog posts ID.
  String getNextPostID() {
    return (IDs[0] + 1).toString();
  }

  // Generate JSON feed
  String getJSONFeed() {
    List posts = List();

    IDs.forEach((int postId) {
      BlogPost post = getBlogPost(postId);
      Map jsonPost = {};
      jsonPost['id'] = post._id;
      jsonPost['date'] = post._date;
      jsonPost['title'] = post._title;
      jsonPost['url'] = 'http://127.0.0.1:3000/post${post._id}.html';
      posts.add(jsonPost);
    });

    return json.encode(posts);
  }

  // Generate RSS feed
  String getRSSFeed() {
    var RssXb = XmlBuilder();
    RssXb.processing('xml', 'version="1.0"');

    RssXb.element('rss', attributes: {'version': '1.0'}, nest: () {
      RssXb.element('channel', nest: () {
        IDs.forEach((int postId) {
          BlogPost post = getBlogPost(postId);
          RssXb.element('item', nest: () {
            RssXb.element('pubDate', nest: () {
              RssXb.text(post._date);
            });
            RssXb.element('title', nest: () {
              RssXb.text(post._title);
            });
            RssXb.element('link', nest: () {
              RssXb.text('http://127.0.0.1:3000/post${post._id}.html');
            });
          });
        });
      });
    });

    var xml = RssXb.buildDocument();
    return xml.toXmlString(pretty: true);
  }
}

/// Clas Blog Post
class BlogPost {
  List<String> _source;

  int _id;
  String _title;
  String _date;
  String _html;

  String get HTML => _html;

  BlogPost(String fileName, this._id) {
    File postFile = File(fileName);
    _source = postFile.readAsLinesSync();
    process();
  }

  // Create an HTML Blog post from the source.
  process() {
    // Extract components.
    _date = _source[0];
    _title = _source[1];

    // Build.
    _html = '<h2>$_title</h2><b>$_date</b><br/>';
    _html += '<img src="$_id.png" align="left">';
    _source.sublist(2).forEach((line) => _html += line);
    _html += '<br/><a href="post$_id.html">Permalink</a>';
  }

  //
  static String createBlogPost(String title, String body) {
    var now = DateTime.now();
    var postDate = DateTime(now.year, now.month, now.day);
    var dateOfPost = '${postDate.month}/${postDate.day}/${postDate.year}';
    return '$title\r\n$dateOfPost\r\n$body\r\n';
  }
}
