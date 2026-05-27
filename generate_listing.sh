cat << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Listing</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
            color: #333;
        }
        h1 {
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin: 10px 0;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 4px;
            transition: background 0.2s;
        }
        li:hover {
            background: #f0f0f0;
        }
        a {
            color: #0066cc;
            text-decoration: none;
            font-weight: 500;
        }
        a:hover {
            text-decoration: underline;
        }
        .empty-message {
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>

    <h1>Available Documents</h1>
    <ul>
EOF

for file in cheatsheets/*.typ; do
    filename=$(basename "$file" .typ)
    echo "        <li><a href=\"${filename}.pdf\" target=\"_blank\">${filename}</a></li>"
done

cat << EOF
    </ul>

</body>
</html>
EOF
