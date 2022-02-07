#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void buy_ticket(MYSQL *conn) {
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[8];
    MYSQL_TIME data;
    MYSQL_TIME nascita;

    // Input for the registration routine
    char tratta[46];
    int tratta_int;
    char classe[46];
    int classe_int;
    char codice_fiscale[46];
    char nome[46];
    char cognome[46];
    char cc[46];

    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    char nascita_anno[46];
    char nascita_mese[46];
    char nascita_giorno[46];

    // Get the required information
    printf("\nRide Date: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nRailway Line: ");
    getInput(46, tratta, false);
    printf("\nClass: ");
    getInput(46, classe, false);
    printf("\nCodice Fiscale: ");
    getInput(46, codice_fiscale, false);
    printf("\nnome: ");
    getInput(46, nome, false);
    printf("\nCognome: ");
    getInput(46, cognome, false);
    printf("\nDate of Birth: ");
    printf("\nYear: ");
    getInput(46, nascita_anno, false);
    printf("\nMonth: ");
    getInput(46, nascita_mese, false);
    printf("\nDay: ");
    getInput(46, nascita_giorno, false);
    printf("\nCredit Card number: ");
    getInput(46, cc, false);

    // Apply proper type conversions
    tratta_int = atoi(tratta);
    classe_int = atoi(classe);

    // Prepare stored procedure call
    if (!setup_prepared_stmt(&prepared_stmt, "call acquista_biglietto(?, ?, ?, ?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_DATE;
    param[0].buffer = (char *) &data;
    param[0].buffer_length = sizeof(data);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &tratta_int;
    param[1].buffer_length = sizeof(tratta_int);

    param[2].buffer_type = MYSQL_TYPE_LONG;
    param[2].buffer = &classe_int;
    param[2].buffer_length = sizeof(classe_int);

    param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[3].buffer = codice_fiscale;
    param[3].buffer_length = strlen(codice_fiscale);

    param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[4].buffer = nome;
    param[4].buffer_length = strlen(nome);

    param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[5].buffer = cognome;
    param[5].buffer_length = strlen(cognome);

    param[6].buffer_type = MYSQL_TYPE_DATE;
    param[6].buffer = (char *) &nascita;
    param[6].buffer_length = sizeof(nascita);

    param[7].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[7].buffer = cc;
    param[7].buffer_length = strlen(cc);


    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not buy ticket\n", true);
    }

    // Dump the result set
    dump_result_set(conn, prepared_stmt, "\nTicket data:");
    mysql_stmt_close(prepared_stmt);
}

void run_as_buyer(MYSQL *conn) {

        char options[3] = {'1', '2', '3'};
        char op;

        printf("Switching to buyer role...\n");

        if (!parse_config("users/Acquirente.json", &conf)) {
            fprintf(stderr, "Unable to load buyer configuration\n");
            exit(EXIT_FAILURE);
        }

        if (mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
            fprintf(stderr, "mysql_change_user() failed\n");
            exit(EXIT_FAILURE);
        }

        while (true) {
            printf("\033[2J\033[H");
            printf("*** What should I do for you? ***\n\n");
            printf("1) Buy Ticket\n");
            printf("2) Quit\n");

            op = multiChoice("Select an option", options, 2);

            switch (op) {
                case '1':
                    buy_ticket(conn);
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
