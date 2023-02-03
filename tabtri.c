#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define COLS 10

int compare(const void *a, const void *b) {
    int *ia = (int*)a;
    int *ib = (int*)b;
    return ia[0] - ib[0];
}

int main() {
    int i, j;
    int rows = 0;
    int **csv;
    FILE *fp;
    char line[1024];

    // Ouverture du fichier data.csv en mode lecture
    fp = fopen("data.csv", "r");
    if (!fp) {
        printf("Impossible d'ouvrir le fichier data.csv\n");
        return 1;
    }

    // Comptage du nombre de lignes dans le fichier
    while (fgets(line, 1024, fp)) {
        rows++;
    }
    fclose(fp);

    // Allocation dynamique du tableau
    csv = (int**)malloc(rows * sizeof(int*));
    for (i = 0; i < rows; i++) {
        csv[i] = (int*)malloc(COLS * sizeof(int));
    }

    // Ouverture du fichier data.csv en mode lecture
    fp = fopen("data.csv", "r");
    if (!fp) {
        printf("Impossible d'ouvrir le fichier data.csv\n");
        return 1;
    }

    // Lecture des données du fichier
    i = 0;
    while (fgets(line, 1024, fp)) {
        char *token = strtok(line, ",");
        for (j = 0; j < COLS && token; j++) {
            csv[i][j] = atoi(token);
            token = strtok(NULL, ",");
        }
        i++;
    }
    fclose(fp);

    // Tri du tableau en fonction de la première colonne
    qsort(csv, rows, sizeof(csv[0]), compare);

    // Ouverture du fichier data.csv en mode écriture
    fp = fopen("data.csv", "w");
    if (!fp) {
        printf("Impossible d'ouvrir le fichier data.csv\n");
        return 1;
    }
    //Ecriture des données triées dans le fichier
    for (i = 0; i < rows; i++) {
        for (j = 0; j < COLS; j++) {
            fprintf(fp, "%d", csv[i][j]);
            if (j < COLS - 1) {
                fprintf(fp, ",");
            }
        }
        fprintf(fp, "\n");
    }
    fclose(fp);

    return 0;
}
