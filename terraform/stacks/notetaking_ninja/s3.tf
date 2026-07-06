
resource "aws_s3_bucket" "notetaking_ninja" {
    name = "notetaking.ninja"
}

resource "aws_s3_bucket_website_configuration" "notetaking_ninja" {
    bucket = aws_s3_bucket.notetaking_ninja.name
    index_document {
        suffix = "index.html"
    }
}

resource "aws_s3_object {
    bucket = aws_s3_bucket.notetaking_ninja.name
    content = "Hello"
}
