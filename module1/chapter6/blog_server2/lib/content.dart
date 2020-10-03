library content;

const String page404 = '''<html>
<head><title>404 - Not Found</title></head>
<body>
<h1>404 - Page Not Found.</h1>
</body>
''';

const String robotsTxt = '''User-Agent: *
Disallow:''';

const String loginForm = '''
<h1>Blog Admin</h1>
<form action="login" method="post">
User: &nbsp;
<input type="text" name="username" />
<br>
Pwd: &nbsp;
<input type="password" name="psword" />
<br>
<input type="submit" value="Log In" />
</form>
''';

const String addForm = '''
<h1>Add Blog Entry</h1>
<form action="add" method="post">
<b>Title</b>
<br/>
<input type="text" name="username" />
<br/>

<b>Entrey</b>
<br/>

<textarea type="text" cols="40" rows="10" name="body"></textarea>
<br/>
<input type="submit" value="Post" />
</form>
''';

const String wrongPassword = '''
<h1>Login Failed</h1>
''';

//const String expectedHash = 'bdf252c8385e7c4ae76bca280acd8d44f85d7fdb56f1bfb44f5749ff549ba2f6';
const String expectedHash = '9b71e8e009b9e421f8c26bab063f8787ed3c3f5098d45f01aca2c1a68d3b7668';
