library blog_entities;

import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;

//// Class for a blog websites
class Blog {
  final String _pathPosts;
  final String _pathImgs;

  List<int> IDs = <int>[];
  Map<int, String> postPaths = <int, String>{};
  Map<int, String> imgPaths = <int, String>{};

  Blog(this._pathPosts, this._pathImgs) {
    _loadPostList();
    _loadImgList();
  }

  void _loadPostList() {
    print('Loading from $_pathPosts');
    var blogContent = Directory(_pathPosts);

    // Load up all the blog posts do get a list of IDs
    blogContent.list().forEach((f) {
      var postFilename = path.basename(f.path).replaceAll('.txt', '');
      var id = int.parse(postFilename);
      IDs.add(id);
      postPaths[id] = f.path;
    }).then((v) {
      // Get a list of blog post IDs organized High to Low
      IDs.sort();
      IDs = IDs.reversed.toList();
    });
  }

  void _loadImgList() {
    print('Loading from $_pathImgs');
    var imgContent = Directory(_pathImgs);

    // Load up all the blog posts do get a list of IDs
    imgContent.list().forEach((f) {
      var postFilename = path.basename(f.path).replaceAll('.png', '');
      var id = int.parse(postFilename);
      imgPaths[id] = f.path;
    });
  }

  // Build a single post the blog.
  BlogPost getBlogPost(int index) {
    return BlogPost(postPaths[index], index.toString());
  }

  // Build a single post the blog.
  File getBlogImage(int index) {
    return File(imgPaths[index]);
  }

  // Build the front page of the blog
  String getFrontPage() {
    var frontPage = '';

    IDs.sublist(0, min(5, IDs.length)).forEach((int postID) {
      var post = getBlogPost(postID);
      frontPage += post.HTML + '<hr/>';
    });

    return frontPage;
  }
}

// Class Blog post
class BlogPost {
  List<String> _source;

  final String _id;
  String _title;
  String _date;
  String _html;

  String get HTML {
    return _html;
  }

  // Load in the blog post.
  BlogPost(String fileName, this._id) {
    var postFile = File(fileName);
    _source = postFile.readAsLinesSync();
    process();
  }

  // Create an HTML blog post from the source
  void process() {
    // Extract components
    _html = '';
    _date = _source[0];
    _title = _source[1];

    // Build
    _html = '<h2>$_title</h2><b>$_date</b><br/>';
    _html += '<img src="/$_id.png" align="left" />';
    _source.sublist(2).forEach((line) => _html += line);
    _html += '<br/><a href="post$_id.html">Permalink</a>';
  }
}
