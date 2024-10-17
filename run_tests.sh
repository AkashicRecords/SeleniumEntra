#!/bin/bash

# Run the Selenium tests
dotnet test SeleniumTestFramework/SeleniumTests.csproj --logger:"console;verbosity=detailed" | tee test_output.log

# Extract test results and generate JSON
poetry run python3 << END
import re
import json
from datetime import datetime

with open('test_output.log', 'r') as f:
    content = f.read()

pattern = r'(.*?) \((.*?)\) \((.+?)\)'
matches = re.findall(pattern, content)

test_results = []
for match in matches:
    name, status, duration = match
    start_time = datetime.now().strftime('%H:%M')
    execution_time = int(float(duration.replace('ms', '').strip()))
    test_results.append({
        'name': name.strip(),
        'status': status,
        'start_time': start_time,
        'execution_time': execution_time
    })

print(json.dumps(test_results))
END

# Generate the HTML report
poetry run python3 ReportGenerator/report_generator.py "$PULL_REQUEST_NUMBER"

echo "Test execution completed. Report generated as test_report.html"
