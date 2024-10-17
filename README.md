# Azure/Entra Authentication and Selenium Test Container

This project provides a self-contained Docker container solution for authenticating with Microsoft Azure/Entra and running Selenium tests against a System Under Test (SUT) hosted on an existing Azure VM.

## Prerequisites

- Docker installed on your local machine
- Azure subscription with access to the target VM
- Azure/Entra credentials for authentication
- Poetry (for local development)

## Setup Instructions

1. Clone the Repository:
   ```bash
   git clone https://github.com/yourusername/yourrepository.git
   cd yourrepository
   ```

2. Set Environment Variables:
   Create a `.env` file in the project root with the following content:
   ```
   AZURE_CLIENT_ID=your_client_id
   AZURE_TENANT_ID=your_tenant_id
   AZURE_CLIENT_SECRET=your_client_secret
   ```
   Replace the values with your actual Azure credentials.

3. Build the Docker Container:
   ```bash
   docker build -t azure-selenium-container .
   ```

4. Run the Container and Tests:
   ```bash
   docker run --env-file .env azure-selenium-container
   ```

## Local Development

If you want to develop or run tests locally:

1. Install Poetry:
   ```bash
   pip install poetry
   ```

2. Install dependencies:
   ```bash
   poetry install
   ```

3. Run tests:
   ```bash
   poetry run bash run_tests.sh
   ```

## Understanding the Output

After running the tests, an HTML report will be generated in the container. To view it:

1. Copy the report from the container:
   ```bash
   docker cp <container_id>:/app/test_report.html ./test_report.html
   ```
   Replace `<container_id>` with the ID of your running container.

2. Open `test_report.html` in your web browser to view the test results.

The report includes:
- Total number of tests run
- A pie chart showing passed, failed, and skipped tests
- A table with details for each test case

## Troubleshooting

- If authentication fails, double-check your Azure credentials in the `.env` file.
- Ensure your Azure VM and the SUT are accessible from the container's network.
- For local development issues, ensure you have the correct Python version (3.9+) and Poetry installed.

## Contributing

[Add contribution guidelines here]

## License

[Add license information here]
