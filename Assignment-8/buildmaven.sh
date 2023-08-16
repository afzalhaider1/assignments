#!/bin/bash

while getopts "ais:t:d" opt; do
    case $opt in
        a)
            mvn package
            ;;
        i)
            mvn install
            ;;
        s)
            case $OPTARG in
                checkstyle)
                    mvn checkstyle:check
                    ;;
                findbugs)
                    mvn findbugs:check
                    ;;
                pmd)
                    mvn pmd:check
                    ;;
                *)
                    echo "Invalid analysis tool. Use 'checkstyle', 'findbugs', or 'pmd'."
                    exit 1
                    ;;
            esac
            ;;
        t)
            case $OPTARG in
                surefire)
                    if [ -z "$3" ]; then
                        report_format="html"
                    else
                        report_format="$3"
                    fi
                    case $report_format in
                        xml)
                            mvn surefire-report:report > unit_test_report.xml
                            ;;
                        csv)
                            mvn surefire-report:report > unit_test_report.csv
                            ;;
                        html)
                            mvn surefire-report:report > unit_test_report.html
                            ;;
                        *)
                            echo "Invalid file format. Use 'xml', 'csv', or 'html'."
                            exit 1
                            ;;
                    esac
                    ;;
                cobertura)
                    if [ -z "$3" ]; then
                        report_format="html"
                    else
                        report_format="$3"
                    fi
                    case $report_format in
                        xml)
                            mvn cobertura:cobertura > code_coverage_report.xml
                            ;;
                        csv)
                            mvn cobertura:cobertura > code_coverage_report.csv
                            ;;
                        html)
                            mvn cobertura:cobertura > code_coverage_report.html
                            ;;
                        *)
                            echo "Invalid file format. Use 'xml', 'csv', or 'html'."
                            exit 1
                            ;;
                    esac
                    ;;
                *)
                    echo "Invalid unit test plugin. Use 'surefire' or 'cobertura'."
                    exit 1
                    ;;
            esac
            ;;
        d)
            sudo cp target/*.war "/var/lib/tomcat9/webapps"
            ;;
        *)
            echo "Invalid option: Use -a, -i, -s, -t, or -d"
            exit 1
            ;;
    esac
done

