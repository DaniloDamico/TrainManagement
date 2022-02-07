#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void validate_ticket(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    char ticket[46];
    int ticket_int;

    // Get the required information
    printf("\nTicket Id: ");
    getInput(46, ticket, false);

    // Apply proper type conversions
    ticket_int = atoi(ticket);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call convalida_biglietto(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_LONG;
    param[0].buffer = &ticket_int;
    param[0].buffer_length = sizeof(ticket_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while validating the ticket.");
    }

    mysql_stmt_close(prepared_stmt);
}

static void check_ticket(MYSQL *conn){

    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    char ticket[46];
    int ticket_int;

    // Get the required information
    printf("\nTicket Id: ");
    getInput(46, ticket, false);

    // Apply proper type conversions
    ticket_int = atoi(ticket);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call verifica_biglietto(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_LONG;
    param[0].buffer = &ticket_int;
    param[0].buffer_length = sizeof(ticket_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while checking the ticket.");
    }

    // Dump the result set
    dump_result_set(conn, prepared_stmt, "\nList of exams assigned to you");
    mysql_stmt_close(prepared_stmt);
}

void run_as_inspector(MYSQL* conn) {
    char options[2] = {'1','2'};
	char op;
	
	printf("Switching to inspector role...\n");

	if(!parse_config("users/Controllore.json", &conf)) {
		fprintf(stderr, "Unable to load inspector configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Validate ticket\n");
		printf("2) Check ticket information\n");
        printf("3) Quit\n");

		op = multiChoice("Select an option", options, 2);

		switch(op) {
			case '1':
				validate_ticket(conn);
				break;
				
			case '2':
                check_ticket(conn);
				break;

            case '3':
                return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}