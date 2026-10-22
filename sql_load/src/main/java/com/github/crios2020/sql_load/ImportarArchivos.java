package com.github.crios2020.sql_load;

import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

public class ImportarArchivos {

    private static final String URL =
        "jdbc:mariadb://localhost:3306/estadisticas_eph";

    // Preferentemente definir estas variables de entorno.
    private static final String USUARIO =
        System.getenv().getOrDefault("DB_USER", "root");

    private static final String CLAVE =
        System.getenv().getOrDefault("DB_PASSWORD", "");

    private static final String SQL = """
        INSERT INTO personas_tic_eph (
            codusu, nro_hogar, componente, ano4, trimestre,
            aglomerado, pond_tic, respondente,
            ip_iii_04, ip_iii_05, ip_iii_06
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

    public static void main(String[] args) {

        if (args.length == 0) {
            System.err.println(
                "Uso: java ImportarPersonasTIC archivo.csv"
            );
            System.exit(1);
        }

        Path archivo = Path.of(args[0]);
        int total = 0;

        CSVFormat formato = CSVFormat.DEFAULT.builder()
            .setDelimiter(';')
            .setQuote('"')
            .setHeader()
            .setSkipHeaderRecord(true)
            .get();

        try (
            Reader lector = Files.newBufferedReader(
                archivo, StandardCharsets.UTF_8
            );
            CSVParser csv = formato.parse(lector);
            Connection conexion = DriverManager.getConnection(
                URL, USUARIO, CLAVE
            );
            PreparedStatement ps = conexion.prepareStatement(SQL)
        ) {
            conexion.setAutoCommit(false);

            try {
                for (CSVRecord fila : csv) {

                    ps.setString(1, fila.get("CODUSU"));
                    ps.setInt(2, Integer.parseInt(
                        fila.get("NRO_HOGAR")));
                    ps.setInt(3, Integer.parseInt(
                        fila.get("COMPONENTE")));
                    ps.setInt(4, Integer.parseInt(
                        fila.get("ANO4")));
                    ps.setInt(5, Integer.parseInt(
                        fila.get("TRIMESTRE")));
                    ps.setInt(6, Integer.parseInt(
                        fila.get("AGLOMERADO")));

                    String ponderador = fila.get("POND_TIC").trim();

                    if (ponderador.isEmpty()) {
                        ps.setNull(7, Types.DECIMAL);
                    } else {
                        ps.setBigDecimal(7,
                            new java.math.BigDecimal(ponderador));
                    }

                    setTexto(ps, 8, fila.get("RESPONDENTE"));
                    setTexto(ps, 9, fila.get("IP_III_04"));
                    setTexto(ps, 10, fila.get("IP_III_05"));
                    setTexto(ps, 11, fila.get("IP_III_06"));

                    ps.addBatch();
                    total++;

                    // Ejecutar lotes de 500 registros.
                    if (total % 500 == 0) {
                        ps.executeBatch();
                        ps.clearBatch();
                    }
                }

                // Insertar los registros restantes.
                ps.executeBatch();
                conexion.commit();

                System.out.println(
                    "Importación finalizada. Registros procesados: "
                    + total
                );

            } catch (Exception e) {
                conexion.rollback();
                throw e;
            }

        } catch (Exception e) {
            System.err.println("Error durante la importación: "
                + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static void setTexto(
        PreparedStatement ps, int posicion, String valor
    ) throws SQLException {

        if (valor == null || valor.isBlank()) {
            ps.setNull(posicion, Types.VARCHAR);
        } else {
            ps.setString(posicion, valor.trim());
        }
    }
}

