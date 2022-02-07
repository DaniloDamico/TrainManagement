#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void add_company(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[3];

    char partita_iva[46];
    char recapito[46];
    char ragione_sociale[46];

    // Get the required information
    printf("\nPartita IVA: ");
    getInput(46, partita_iva, false);
    printf("\nAddress: ");
    getInput(46, recapito, false);
    printf("\nName: ");
    getInput(46, ragione_sociale, false);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_azienda(?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = partita_iva;
    param[0].buffer_length = strlen(partita_iva);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = recapito;
    param[1].buffer_length = strlen(recapito);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = ragione_sociale;
    param[2].buffer_length = strlen(ragione_sociale);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not add company\n", true);
    } else {
        printf("RCompany correctly added...\n");
    }

}

static void add_passenger_car_ride(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[5];
    MYSQL_TIME data;

    // Input for the registration routine
    char tratta[46];
    int tratta_int;
    char treno[46];
    char conducente[46];
    char capotreno[46];
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nDate: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nRailway Line: ");
    getInput(46, tratta, false);
    printf("\nTreno: ");
    getInput(46, treno, false);
    printf("\nDriver: ");
    getInput(46, conducente, false);
    printf("\nConductor: ");
    getInput(46, capotreno, false);

    // Apply proper type conversions
    tratta_int = atoi(tratta);
    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_corsa_treno_passeggeri(?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_DATE;
    param[0].buffer = (char*)&data;
    param[0].buffer_length = sizeof(data);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &tratta_int;
    param[1].buffer_length = sizeof(tratta_int);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = treno;
    param[2].buffer_length = strlen(treno);

    param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[3].buffer = conducente;
    param[3].buffer_length = strlen(conducente);

    param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[4].buffer = capotreno;
    param[4].buffer_length = strlen(capotreno);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the ride.");
    } else {
        printf("Ride correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_boxcar_ride(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[4];
    MYSQL_TIME data;

    // Input for the registration routine
    char tratta[46];
    int tratta_int;
    char treno[46];
    char conducente[46];
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nDate: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nRailway Line: ");
    getInput(46, tratta, false);
    printf("\nTreno: ");
    getInput(46, treno, false);
    printf("\nDriver: ");
    getInput(46, conducente, false);

    // Apply proper type conversions
    tratta_int = atoi(tratta);
    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_corsa_treno_merci(?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_DATE;
    param[0].buffer = (char*)&data;
    param[0].buffer_length = sizeof(data);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &tratta_int;
    param[1].buffer_length = sizeof(tratta_int);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = treno;
    param[2].buffer_length = strlen(treno);

    param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[3].buffer = conducente;
    param[3].buffer_length = strlen(conducente);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the ride.");
    } else {
        printf("Ride correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_employee(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[7];
    MYSQL_TIME data;

    char options[2] = {'1','2'};
    char r;
    // Input for the registration routine
    char codice_fiscale[46];
    char nome[46];
    char cognome[46];
    char citta[46];
    char ruolo[46];
    char provincia[46];
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nCodice Fiscale: ");
    getInput(46, codice_fiscale, false);
    printf("Nome: ");
    getInput(46, nome, false);
    printf("Cognome: ");
    getInput(46, cognome, false);
    printf("Date of Birth: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);

    printf("\nBirth city: ");
    getInput(46, citta, false);

    printf("Assign a possible role:\n");
    printf("\t1) Conducente\n");
    printf("\t2) Capotreno\n");
    r = multiChoice("Select role", options, 3);

    // Convert role into enum value
    switch(r) {
        case '1':
            strcpy(ruolo, "conducente");
            break;
        case '2':
            strcpy(ruolo, "capotreno");
            break;
        default:
            fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
            abort();
    }

    printf("\nBirth provincia: ");
    getInput(46, provincia, false);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_lavoratore(?, ?, ?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = codice_fiscale;
    param[0].buffer_length = strlen(codice_fiscale);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = nome;
    param[1].buffer_length = strlen(nome);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = cognome;
    param[2].buffer_length = strlen(cognome);

    param[3].buffer_type = MYSQL_TYPE_DATE;
    param[3].buffer = (char*)&data;
    param[3].buffer_length = sizeof(data);

    param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[4].buffer = citta;
    param[4].buffer_length = strlen(citta);

    param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[5].buffer = ruolo;
    param[5].buffer_length = strlen(ruolo);

    param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[6].buffer = provincia;
    param[6].buffer_length = strlen(provincia);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the employee.");
    } else {
        printf("Employee correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_shipping(MYSQL *conn) {

    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[7];
    MYSQL_TIME data;

    // Input for the registration routine
    char mittente[46];
    char destinatario[46];
    char merce[46];
    char massa[46];
    int massa_int;
    char vagone[46];
    int vagone_int;
    char tratta[46];
    int tratta_int;
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nSender: ");
    getInput(46, mittente, false);
    printf("Addressee: ");
    getInput(46, destinatario, false);
    printf("Goods: ");
    getInput(46, merce, false);
    printf("Weight: ");
    getInput(46, massa, false);
    printf("Boxcar: ");
    getInput(46, vagone, false);
    printf("Shipment date: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("Railway Line: ");
    getInput(46, tratta, false);

    // Apply proper type conversions
    massa_int = atoi(massa);
    vagone_int = atoi(vagone);
    tratta_int = atoi(tratta);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_spedizione(?, ?, ?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = mittente;
    param[0].buffer_length = strlen(mittente);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = destinatario;
    param[1].buffer_length = strlen(destinatario);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = merce;
    param[2].buffer_length = strlen(merce);

    param[3].buffer_type = MYSQL_TYPE_LONG;
    param[3].buffer = &massa_int;
    param[3].buffer_length = sizeof(massa_int);

    param[4].buffer_type = MYSQL_TYPE_LONG;
    param[4].buffer = &vagone_int;
    param[4].buffer_length = sizeof(vagone_int);

    param[5].buffer_type = MYSQL_TYPE_DATE;
    param[5].buffer = (char*)&data;
    param[5].buffer_length = sizeof(data);

    param[6].buffer_type = MYSQL_TYPE_LONG;
    param[6].buffer = &tratta_int;
    param[6].buffer_length = sizeof(tratta_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the shipment.");
    } else {
        printf("Shipment correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);

}

static void add_goods_train(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[8];
    MYSQL_TIME data;

    // Input for the registration routine
    char matricola[46];
    char numero_vagoni[46];
    int numero_vagoni_int;
    char marca_locomotrice[46];
    char modello_locomotrice[46];
    char marca_vagone[46];
    char modello_vagone[46];
    char portata[46];
    int portata_int;
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nSerial Number: ");
    getInput(46, matricola, false);
    printf("\nNumero Vagoni: ");
    getInput(46, numero_vagoni, false);
    printf("\nDate of Purchase: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nLocomotive Brand: ");
    getInput(46, marca_locomotrice, false);
    printf("\nLocomotive Model: ");
    getInput(46, modello_locomotrice, false);
    printf("\nBoxcar Brand: ");
    getInput(46, marca_vagone, false);
    printf("\nBoxcar Model: ");
    getInput(46, modello_vagone, false);
    printf("\nCarrying Capacity: ");
    getInput(46, portata, false);

    // Apply proper type conversions
    numero_vagoni_int = atoi(numero_vagoni);
    portata_int = atoi(portata);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_treno_merci(?, ?, ?, ?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = matricola;
    param[0].buffer_length = strlen(matricola);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &numero_vagoni_int;
    param[1].buffer_length = sizeof(numero_vagoni_int);

    param[2].buffer_type = MYSQL_TYPE_DATE;
    param[2].buffer = (char*)&data;
    param[2].buffer_length = sizeof(data);

    param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[3].buffer = marca_locomotrice;
    param[3].buffer_length = strlen(marca_locomotrice);

    param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[4].buffer = modello_locomotrice;
    param[4].buffer_length = strlen(modello_locomotrice);

    param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[5].buffer = marca_vagone;
    param[5].buffer_length = strlen(marca_vagone);

    param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[6].buffer = modello_vagone;
    param[6].buffer_length = strlen(modello_vagone);

    param[7].buffer_type = MYSQL_TYPE_LONG;
    param[7].buffer = &portata_int;
    param[7].buffer_length = sizeof(portata_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the train.");
    } else {
        printf("Train correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_passenger_train(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[13];
    MYSQL_TIME data;

    // Input for the registration routine
    char matricola[46];
    char numero_vagoni[46];
    int numero_vagoni_int;
    char carrozze_prima[46];
    int carrozze_prima_int;
    char carrozze_seconda[46];
    int carrozze_seconda_int;
    char marca_locomotrice[46];
    char modello_locomotrice[46];
    char marca_vagone_prima[46];
    char modello_vagone_prima[46];
    char passeggeri_prima[46];
    int passeggeri_prima_int;
    char marca_vagone_seconda[46];
    char modello_vagone_seconda[46];
    char passeggeri_seconda[46];
    int passeggeri_seconda_int;
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];


    // Get the required information
    printf("\nSerial Number: ");
    getInput(46, matricola, false);
    printf("\nNumero Vagoni: ");
    getInput(46, numero_vagoni, false);
    printf("\nDate of Purchase: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nNumber of I Class Passenger Cars: ");
    getInput(46, carrozze_prima, false);
    printf("\nNumber of II Class Passenger Cars: ");
    getInput(46, carrozze_seconda, false);
    printf("\nLocomotive Brand: ");
    getInput(46, marca_locomotrice, false);
    printf("\nLocomotive Model: ");
    getInput(46, modello_locomotrice, false);
    printf("\nI Class Passenger Car Brand: ");
    getInput(46, marca_vagone_prima, false);
    printf("\nI Class Passenger Car Model: ");
    getInput(46, modello_vagone_prima, false);
    printf("\nMax I Class Passenger in a Car: ");
    getInput(46, passeggeri_prima, false);
    printf("\nII Class Passenger Car Brand: ");
    getInput(46, marca_vagone_seconda, false);
    printf("\nII Class Passenger Car Model: ");
    getInput(46, modello_vagone_seconda, false);
    printf("\nMax II Class Passenger in a Car: ");
    getInput(46, passeggeri_seconda, false);


    // Apply proper type conversions
    numero_vagoni_int = atoi(numero_vagoni);
    carrozze_prima_int = atoi(carrozze_prima);
    carrozze_seconda_int = atoi(carrozze_seconda);
    passeggeri_prima_int = atoi(passeggeri_prima);
    passeggeri_seconda_int = atoi(passeggeri_seconda);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call aggiungi_treno_passeggeri(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = matricola;
    param[0].buffer_length = strlen(matricola);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &numero_vagoni_int;
    param[1].buffer_length = sizeof(numero_vagoni_int);

    param[2].buffer_type = MYSQL_TYPE_DATE;
    param[2].buffer = (char*)&data;
    param[2].buffer_length = sizeof(data);

    param[3].buffer_type = MYSQL_TYPE_LONG;
    param[3].buffer = &carrozze_prima_int;
    param[3].buffer_length = sizeof(carrozze_prima_int);

    param[4].buffer_type = MYSQL_TYPE_LONG;
    param[4].buffer = &carrozze_seconda_int;
    param[4].buffer_length = sizeof(carrozze_seconda_int);

    param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[5].buffer = marca_locomotrice;
    param[5].buffer_length = strlen(marca_locomotrice);

    param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[6].buffer = modello_locomotrice;
    param[6].buffer_length = strlen(modello_locomotrice);

    param[7].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[7].buffer = marca_vagone_prima;
    param[7].buffer_length = strlen(marca_vagone_prima);

    param[8].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[8].buffer = modello_vagone_prima;
    param[8].buffer_length = strlen(modello_vagone_prima);

    param[9].buffer_type = MYSQL_TYPE_LONG;
    param[9].buffer = &passeggeri_prima_int;
    param[9].buffer_length = sizeof(passeggeri_prima_int);

    param[10].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[10].buffer = marca_vagone_seconda;
    param[10].buffer_length = strlen(marca_vagone_seconda);

    param[11].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[11].buffer = modello_vagone_seconda;
    param[11].buffer_length = strlen(modello_vagone_seconda);

    param[12].buffer_type = MYSQL_TYPE_LONG;
    param[12].buffer = &passeggeri_seconda_int;
    param[12].buffer_length = sizeof(passeggeri_seconda_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the train.");
    } else {
        printf("Train correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_user(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[3];
    char options[5] = {'1','2', '3', '4', '5'};
    char r;

    // Input for the registration routine
    char username[46];
    char password[46];
    char ruolo[46];

    // Get the required information
    printf("\nUsername: ");
    getInput(46, username, false);
    printf("password: ");
    getInput(46, password, true);
    printf("Assign a possible role:\n");
    printf("\t1) Acquirente\n");
    printf("\t2) Addetto alla manutenzione\n");
    printf("\t3) Controllore\n");
    printf("\t4) Gestore del servizio\n");
    printf("\t5) Lavoratore\n");
    r = multiChoice("Select role", options, 3);

    // Convert role into enum value
    switch(r) {
        case '1':
            strcpy(ruolo, "Acquirente");
            break;
        case '2':
            strcpy(ruolo, "Addetto_alla_manutenzione");
            break;
        case '3':
            strcpy(ruolo, "Controllore");
            break;
        case '4':
            strcpy(ruolo, "Gestore_del_servizio");
            break;
        case '5':
            strcpy(ruolo, "Lavoratore");
            break;
        default:
            fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
            abort();
    }

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call crea_utente(?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize user insertion statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = username;
    param[0].buffer_length = strlen(username);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = password;
    param[1].buffer_length = strlen(password);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = ruolo;
    param[2].buffer_length = strlen(ruolo);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for user insertion\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while adding the user.");
    } else {
        printf("User correctly added...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void add_ride_datetimes(MYSQL *conn){

    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[4];
    MYSQL_TIME data;
    MYSQL_TIME partenza;
    MYSQL_TIME arrivo;

    // Input for the registration routine
    char tratta[46];
    int tratta_int;
    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    char partenza_anno[46];
    char partenza_mese[46];
    char partenza_giorno[46];

    char partenza_ora[46];
    char partenza_minuto[46];
    char partenza_secondo[46];

    char arrivo_anno[46];
    char arrivo_mese[46];
    char arrivo_giorno[46];

    char arrivo_ora[46];
    char arrivo_minuto[46];
    char arrivo_secondo[46];

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
    printf("\nDeparture Datetime: ");
    printf("\nYear: ");
    getInput(46, partenza_anno, false);
    printf("\nMonth: ");
    getInput(46, partenza_mese, false);
    printf("\nDay: ");
    getInput(46, partenza_giorno, false);
    printf("\nHour: ");
    getInput(46, partenza_ora, false);
    printf("\nMinute: ");
    getInput(46, partenza_minuto, false);
    printf("\nSecond: ");
    getInput(46, partenza_secondo, false);
    printf("\nArrival Datetime: ");
    printf("\nYear: ");
    getInput(46, arrivo_anno, false);
    printf("\nMonth: ");
    getInput(46, arrivo_mese, false);
    printf("\nDay: ");
    getInput(46, arrivo_giorno, false);
    printf("\nHour: ");
    getInput(46, arrivo_ora, false);
    printf("\nMinute: ");
    getInput(46, arrivo_minuto, false);
    printf("\nSecond: ");
    getInput(46, arrivo_secondo, false);


    // Apply proper type conversions
    tratta_int = atoi(tratta);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    partenza.year = atoi(partenza_anno);
    partenza.month = atoi(partenza_mese);
    partenza.day = atoi(partenza_giorno);

    partenza.hour = atoi(partenza_ora);
    partenza.minute = atoi(partenza_minuto);
    partenza.second = atoi(partenza_secondo);

    arrivo.year = atoi(arrivo_anno);
    arrivo.month = atoi(arrivo_mese);
    arrivo.day = atoi(arrivo_giorno);

    arrivo.hour = atoi(arrivo_minuto);
    arrivo.minute = atoi(arrivo_minuto);
    arrivo.second = atoi(arrivo_secondo);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_orari_corsa_effettivi(?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_DATE;
    param[0].buffer = (char*)&data;
    param[0].buffer_length = sizeof(data);

    param[1].buffer_type = MYSQL_TYPE_LONG;
    param[1].buffer = &tratta_int;
    param[1].buffer_length = sizeof(tratta_int);

    param[0].buffer_type = MYSQL_TYPE_DATETIME;
    param[0].buffer = (char*)&partenza;
    param[0].buffer_length = sizeof(partenza);

    param[0].buffer_type = MYSQL_TYPE_DATETIME;
    param[0].buffer = (char*)&arrivo;
    param[0].buffer_length = sizeof(arrivo);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while modifying the ride.");
    } else {
        printf("Ride correctly updated...\n");
    }

    mysql_stmt_close(prepared_stmt);

}

static void substitute_employee(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[4];
    MYSQL_TIME data;

    // Input for the registration routine
    char malato[46];
    char sostituto[46];
    char tratta[46];
    int tratta_int;

    char data_anno[46];
    char data_mese[46];
    char data_giorno[46];

    // Get the required information
    printf("\nShift Date: ");
    printf("\nYear: ");
    getInput(46, data_anno, false);
    printf("\nMonth: ");
    getInput(46, data_mese, false);
    printf("\nDay: ");
    getInput(46, data_giorno, false);
    printf("\nSick Employee: ");
    getInput(46, malato, false);
    printf("\nSubstitute Employee: ");
    getInput(46, sostituto, false);
    printf("\nRailway Line: ");
    getInput(46, tratta, false);

    // Apply proper type conversions
    tratta_int = atoi(tratta);

    data.year = atoi(data_anno);
    data.month = atoi(data_mese);
    data.day = atoi(data_giorno);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call sostituisci_lavoratore(?, ?, ?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_DATE;
    param[0].buffer = (char*)&data;
    param[0].buffer_length = sizeof(data);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer = malato;
    param[1].buffer_length = strlen(malato);

    param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[2].buffer = sostituto;
    param[2].buffer_length = strlen(sostituto);

    param[3].buffer_type = MYSQL_TYPE_LONG;
    param[3].buffer = &tratta_int;
    param[3].buffer_length = sizeof(tratta_int);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error (prepared_stmt, "An error occurred while operating the substitution.");
    } else {
        printf("Substitution correctly performed...\n");
    }

    mysql_stmt_close(prepared_stmt);
}

static void view_goods_train_maintenance_history(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    char treno[46];

    // Get the required information
    printf("\nGood Train Serial Number: ");
    getInput(46, treno, false);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call visualizza_storico_treno_merci(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = treno;
    param[0].buffer_length = strlen(treno);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve maintenance history\n", true);
    }

    // Dump the result set
    dump_result_set(conn, prepared_stmt, "\nMaintenance history of the selected train");
    mysql_stmt_close(prepared_stmt);
}

static void view_passengers_train_maintenance_history(MYSQL *conn){
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    char treno[46];

    // Get the required information
    printf("\nPassenger Train Serial Number: ");
    getInput(46, treno, false);

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call visualizza_storico_treno_passeggeri(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[0].buffer = treno;
    param[0].buffer_length = strlen(treno);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve maintenance history\n", true);
    }

    // Dump the result set
    dump_result_set(conn, prepared_stmt, "\nMaintenance history of the selected train");
    mysql_stmt_close(prepared_stmt);
}

void run_as_administrator(MYSQL* conn) {
    	char options[5] = {'1','2', '3', '4', '5'};
	char op;
	
	printf("Switching to administrative role...\n");

	if(!parse_config("users/Gestore_del_servizio.json", &conf)) {
		fprintf(stderr, "Unable to load administrator configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Add company\n");
		printf("2) Add passenger car ride\n");
		printf("3) Add boxcar ride\n");
		printf("4) Add employee\n");
        printf("5) Add shipping\n");
        printf("6) Add goods train\n");
        printf("7) Add passenger train\n");
        printf("8) Add user\n");
        printf("9) Go to page 2\n");

		op = multiChoice("Select an option", options, 5);

		switch(op) {
			case '1':
				add_company(conn);
				break;
			case '2':
				add_passenger_car_ride(conn);
				break;
			case '3':
				add_boxcar_ride(conn);
				break;
			case '4':
				add_employee(conn);
				break;
			case '5':
				add_shipping(conn);
				break;
			case '6':
				add_goods_train(conn);
				break;
			case '7':
				add_passenger_train(conn);
				break;
			case '8':
				add_user(conn);
				break;
			case '9':
                printf("\033[2J\033[H");
                printf("*** What should I do for you? ***\n\n");
                printf("1) Add real ride datetimes\n");
                printf("2) Substitute employee\n");
                printf("3) View goods train maintenance history\n");
                printf("4) View passengers train maintenance history\n");
                printf("5) Quit\n");

                op = multiChoice("Select an option", options, 5);

                switch(op) {
                    case '1':
                        add_ride_datetimes(conn);
                        break;
                    case '2':
                        substitute_employee(conn);
                        break;
                    case '3':
                        view_goods_train_maintenance_history(conn);
                        break;
                    case '4':
                        view_passengers_train_maintenance_history(conn);
                        return;
                    case '5':
                        return;

                    default:
                        fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
                        abort();
                }
                break;

			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}