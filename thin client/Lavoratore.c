#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void add_shifts_report(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[3];
    MYSQL_TIME data_corsa;
    MYSQL_TIME data_report;

    char op;

    char lavoratore[16];
    char rapporto[500];
    int tratta_int;
    char tratta[46];

    // Get the required information
    printf("\nCodice Fiscale: ");
    getInput(46, lavoratore, false);
    printf("Report: ");
    getInput(500, rapporto, false);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call genera_report_sui_turni_di_lavoro(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = lavoratore;
    param[0].buffer_length = strlen(lavoratore);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = rapporto;
    param[1].buffer_length = strlen(rapporto);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the report.");
    } else {
        printf("Report correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);

    while(true){
        char options[2] = {'1','2'};
        printf("If you don't want to add a shift to the report press '1', else press another key\n");
        op = multiChoice("Select an option", options, 2);

        if (op == '1') {
            return;
        }

        // Get the required information
        printf("\nRide Date: ");
        printf("\nYear: ");
        getInput(46, (char*)&data_corsa.year, false);
        printf("\nMonth: ");
        getInput(46, (char*)&data_corsa.month, false);
        printf("\nDay: ");
        getInput(46, (char*)&data_corsa.day, false);
        printf("\nRailway Line: ");
        getInput(46, tratta, false);
        printf("Report Date: ");
        printf("\nYear: ");
        getInput(46, (char*)&data_report.year, false);
        printf("\nMonth: ");
        getInput(46, (char*)&data_report.month, false);
        printf("\nDay: ");
        getInput(46, (char*)&data_report.day, false);

        // Apply proper type conversions
        tratta_int = atoi(tratta);

        // Prepare stored procedure call
        if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_turno_a_report_sui_turni(?, ?, ?)", conn)) {
            finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
        }

        // Prepare parameters
        memset(param, 0, sizeof(param));

        param[0].buffer_type = MYSQL_TYPE_DATE;
        param[0].buffer = (char*)&data_corsa;
        param[0].buffer_length = sizeof(data_corsa);

        param[1].buffer_type = MYSQL_TYPE_LONG;
        param[1].buffer = &tratta_int;
        param[1].buffer_length = sizeof(tratta_int);

        param[2].buffer_type = MYSQL_TYPE_DATE;
        param[2].buffer = (char*)&data_report;
        param[2].buffer_length = sizeof(data_report);

        if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
            finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
        }

        // Run procedure
        if (mysql_stmt_execute(prepared_stmt) != 0) {
            print_stmt_error (prepared_stmt, "An error occurred while adding to the report.");
        } else {
            printf("Report correctly updated...\n");
        }
    }
}

void run_as_employee(MYSQL* conn) {
    char options[2] = {'1','2'};
	char op;
	
	printf("Switching to employee role...\n");

	if(!parse_config("users/Lavoratore.json", &conf)) {
		fprintf(stderr, "Unable to load employee configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Add shifts report\n");
		printf("2) Quit\n");

		op = multiChoice("Select an option", options, 2);

		switch(op) {
			case '1':
				add_shifts_report(conn);
				break;
				
			case '2':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}