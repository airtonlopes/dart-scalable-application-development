/// Object to extract line counts from Source code strings.
class SourceCodeScanner {
  int totalLines = 0;
  int classes = 0;
  int imports = 0;
  int comments = 0;
  int whitespace = 0;

  void scan(List<String> lines) {
    totalLines = lines.length;
    lines.forEach((line) {
      line = line.trim();
      if (line.startsWith('class')) {
        classes++;
      } else if (line.startsWith('import')) {
        imports++;
      } else if (line.startsWith('//')) {
        comments++;
      } else if (line.isEmpty) {
        whitespace++;
      }
    });
  }
}
