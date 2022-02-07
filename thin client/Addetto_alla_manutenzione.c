#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void add_locomotive_maintenance(MYSQL *conn){

    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    char locomotrice[46];
    int locomotrice_int;
    char rapporto[200];

    // Get the required information
    printf("\nLocomotive Id: ");
    getInput(46, locomotrice, false);
    printf("Report: ");
    getInput(200, rapporto, false);

    // Apply proper type conversions
    locomotrice_int = atoi(locomotrice);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_report_manutenzione_locomotrice(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_LONG;
    param[0].buffer = &locomotrice_int;
    param[0].buffer_length = sizeof(locomotrice_int);

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
}


static void add_boxcar_maintenance(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    char vagone[46];
    int vagone_int;
    char rapporto[200];

    // Get the required information
    printf("\nBoxcar Id: ");
    getInput(46, vagone, false);
    printf("Report: ");
    getInput(200, rapporto, false);

    // Apply proper type conversions
    vagone_int = atoi(vagone);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_report_manutenzione_vagone_merci(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_LONG;
    param[0].buffer = &vagone_int;
    param[0].buffer_length = sizeof(vagone_int);

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
}
static void add_passenger_car_maintenance(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    char carrozza[46];
    int carrozza_int;
    char rapporto[200];

    // Get the required information
    printf("\nPassenger Car Id: ");
    getInput(46, carrozza, false);
    printf("Report: ");
    getInput(200, rapporto, false);

    // Apply proper type conversions
    carrozza_int = atoi(carrozza);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_report_manutenzione_vagone_passeggeri(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_LONG;
    param[0].buffer = &carrozza_int;
    param[0].buffer_length = sizeof(carrozza_int);

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
}

void run_as_maintenance(MYSQL* conn) {

    char options[4] = {'1','2', '3', '4'};
	char op;
	
	printf("Switching to maintenance role...\n");

    if(!parse_config("users/Addetto_alla_manutenzione.json", &conf)) {
		fprintf(stderr, "Unable to load maintenance configuration\n");
		exit(EXIT_FAILURE);
	}

    if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

    while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Add locomotive maintenance report\n");
        printf("2) Add boxcar maintenance report\n");
        printf("3) Add passenger car maintenance report\n");
		printf("4) Quit\n");

		op = multiChoice("Select an option", options, 2);

		switch(op) {
			case '1':
				add_locomotive_maintenance(conn);
				break;

            case '2':
				add_boxcar_maintenance(conn);
				break;

            case '3':
				add_passenger_car_maintenance(conn);
				break;

			case '4':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}
