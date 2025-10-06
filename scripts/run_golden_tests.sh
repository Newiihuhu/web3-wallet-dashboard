#!/bin/bash

# Golden Tests Runner Script
# This script helps run golden tests with different options

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -u, --update            Update golden files"
    echo "  -a, --all               Run all golden tests"
    echo "  -b, --basic             Run basic golden tests only"
    echo "  -r, --responsive        Run responsive golden tests only"
    echo "  -c, --clean             Clean golden files before running"
    echo "  -v, --verbose           Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0 --update             Update all golden files"
    echo "  $0 --basic              Run basic golden tests"
    echo "  $0 --responsive         Run responsive golden tests"
    echo "  $0 --all --verbose      Run all tests with verbose output"
}

# Default values
UPDATE_GOLDENS=false
RUN_ALL=false
RUN_BASIC=false
RUN_RESPONSIVE=false
CLEAN_FIRST=false
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -u|--update)
            UPDATE_GOLDENS=true
            shift
            ;;
        -a|--all)
            RUN_ALL=true
            shift
            ;;
        -b|--basic)
            RUN_BASIC=true
            shift
            ;;
        -r|--responsive)
            RUN_RESPONSIVE=true
            shift
            ;;
        -c|--clean)
            CLEAN_FIRST=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# If no specific test type is selected, run all
if [[ "$RUN_ALL" == false && "$RUN_BASIC" == false && "$RUN_RESPONSIVE" == false ]]; then
    RUN_ALL=true
fi

# Build flutter command
FLUTTER_CMD="flutter test"

if [[ "$UPDATE_GOLDENS" == true ]]; then
    FLUTTER_CMD="$FLUTTER_CMD --update-goldens"
fi

if [[ "$VERBOSE" == true ]]; then
    FLUTTER_CMD="$FLUTTER_CMD --reporter=expanded"
else
    FLUTTER_CMD="$FLUTTER_CMD --reporter=compact"
fi

# Clean golden files if requested
if [[ "$CLEAN_FIRST" == true ]]; then
    print_status "Cleaning golden files..."
    find test/presentation/widgets/golden -name "*.png" -delete
    print_success "Golden files cleaned"
fi

# Run tests based on selection
if [[ "$RUN_ALL" == true || "$RUN_BASIC" == true ]]; then
    print_status "Running basic golden tests..."
    $FLUTTER_CMD test/presentation/widgets/simple_golden_tests.dart
    print_success "Basic golden tests completed"
fi

if [[ "$RUN_ALL" == true || "$RUN_RESPONSIVE" == true ]]; then
    print_status "Running responsive golden tests..."
    $FLUTTER_CMD test/presentation/widgets/responsive_golden_tests.dart
    print_success "Responsive golden tests completed"
fi

print_success "All selected golden tests completed successfully!"

# Show summary
echo ""
print_status "Golden test files location:"
echo "  - Basic tests: test/presentation/widgets/golden/"
echo "  - Responsive tests: test/presentation/widgets/golden/responsive/"
echo ""
print_status "To update golden files, run: $0 --update"
print_status "To run specific tests, use: $0 --basic, --responsive"
