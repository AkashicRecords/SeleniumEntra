import sys
import json
from datetime import datetime
import matplotlib.pyplot as plt
import base64
from io import BytesIO

def generate_report(test_results, pull_request_number):
    total_tests = len(test_results)
    passed = sum(1 for test in test_results if test['status'] == 'Passed')
    failed = sum(1 for test in test_results if test['status'] == 'Failed')
    skipped = sum(1 for test in test_results if test['status'] == 'Skipped')

    # Generate pie chart
    plt.figure(figsize=(8, 8))
    plt.pie([passed, failed, skipped], labels=['Passed', 'Failed', 'Skipped'], colors=['green', 'red', 'yellow'], autopct='%1.1f%%')
    plt.title('Test Results')
    
    # Save plot to a base64 string
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    plot_base64 = base64.b64encode(buffer.getvalue()).decode('utf-8')

    # Generate HTML report
    html_content = f"""
    <html>
    <head>
        <title>Pull Request #{pull_request_number} - {datetime.now().strftime('%d/%m/%Y')}</title>
        <style>
            table {{ border-collapse: collapse; width: 100%; }}
            th, td {{ border: 1px solid black; padding: 8px; text-align: left; }}
            th {{ background-color: #f2f2f2; }}
        </style>
    </head>
    <body>
        <h1>Pull Request #{pull_request_number} - {datetime.now().strftime('%d/%m/%Y')}</h1>
        <h2>Total number of tests: {total_tests}</h2>
        <img src="data:image/png;base64,{plot_base64}" alt="Test Results Pie Chart">
        <table>
            <tr>
                <th>Test Case Name</th>
                <th>Status</th>
                <th>Start Time</th>
                <th>Execution Time (ms)</th>
            </tr>
    """

    for test in test_results:
        html_content += f"""
            <tr>
                <td>{test['name']}</td>
                <td>{test['status']}</td>
                <td>{test['start_time']}</td>
                <td>{test['execution_time']}</td>
            </tr>
        """

    html_content += """
        </table>
    </body>
    </html>
    """

    with open('test_report.html', 'w') as f:
        f.write(html_content)

if __name__ == "__main__":
    test_results = json.loads(sys.stdin.read())
    pull_request_number = sys.argv[1]
    generate_report(test_results, pull_request_number)
