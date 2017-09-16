/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tarea2;

import java.io.File;
import weka.core.Attribute;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Normalize;
import weka.core.converters.ArffSaver;

/**
 *
 * @author sergio
 */
public class Tarea2 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        String mainPath = "/home/sergio/MEGAsync/Trabajosfinales/MD/MD2/DataSets/DatasetsSiArff/";
        String file;
        int selectDataSet;
        //selectDataSet = 1; //wine
        selectDataSet = 2; //segmentation
        switch (selectDataSet) {

            case 1:
                file = "wine";
                break;

            case 2:
                file = "SegmentationTrain";
                break;

            default:
                file = "wine";
                break;
        }

        String path = mainPath + file + ".arff";

        /*Construccion del DataSet*/
        DataSource fuente = new DataSource(path);
        Instances dataSet = fuente.getDataSet();
        dataSet.setClassIndex(0);

        int selectFiltro;
        //selectFiltro = 1; // Z-Score
        selectFiltro = 2; // Lineal

        String filtro;
        String stringFiltro;
        switch (selectFiltro) {

            case 1:
                filtro = "-S 1.0 -T 0.0";// Z-Score 
                stringFiltro = "z-score";
                break;

            case 2:
                filtro = "-S 2.0 -T -1.0";// Lineal
                stringFiltro = "lineal";
                break;

            default:
                filtro = "-S 1.0 -T 0.0";// Z-Score 
                stringFiltro = "z-score";
                break;
        }

        /* Filtrado */
        Instances datosFiltrados = Filtro(dataSet, filtro);

        /* Guardamos nuevos dataSet */
        String nameFile;
        nameFile = file + "-" + stringFiltro;
        SaveArff(datosFiltrados, nameFile);

        for (int i = 0; i < dataSet.numAttributes(); i++) {
            /* Estadisticos nuevos dataSets */
            attributeInformation(dataSet, i);
        }

    }

    private static Instances Filtro(Instances dataSet, String TipoFiltrado) throws Exception {
        Normalize filtro = new Normalize();
        String opcion[] = weka.core.Utils.splitOptions(TipoFiltrado);
        filtro.setOptions(opcion);
        filtro.setInputFormat(dataSet);
        Instances datosFiltrados = Filter.useFilter(dataSet, filtro);

        return datosFiltrados;
    }

    private static void SaveArff(Instances datos, String ArchivoName) throws Exception {
        String mainPathSave = "/home/sergio/Escritorio/EntregasCodigos/Tarea2/filtrados/";
        ArffSaver ficheroSalida = new ArffSaver();
        ficheroSalida.setInstances(datos);
        String ruta = mainPathSave + ArchivoName + ".arff";
        ficheroSalida.setFile(new File(ruta));
        ficheroSalida.writeBatch();
    }

    private static void attributeInformation(Instances dataSet, int numAttribute) throws Exception {

        System.out.println("***************************");
        System.out.println("Nombre del Atributo: " + dataSet.attribute(numAttribute).name());
        System.out.println("***************************");
        System.out.println("Summary:\n");
        System.out.println(dataSet.attributeStats(numAttribute));
        System.out.println("***************************");

        Attribute atributo = dataSet.attribute(numAttribute);
        if (!atributo.isNominal()) {
            System.out.println("Otras caracteristicas:\n");
            System.out.println("Mínimo " + dataSet.kthSmallestValue(numAttribute, 1));
            System.out.println("Máximo " + dataSet.kthSmallestValue(numAttribute, dataSet.numInstances()));
            System.out.println("Media " + dataSet.meanOrMode(numAttribute));
            System.out.println("Varianza " + dataSet.variance(numAttribute));
            System.out.println("Desviación típica " + Math.sqrt(dataSet.variance(numAttribute)));
            System.out.println("Prueba " + dataSet.classAttribute());
        } else {
            System.out.println("El atributo es de tipo nominal");
        }
    }

}

