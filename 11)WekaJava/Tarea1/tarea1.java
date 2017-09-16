/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tarea1;

import weka.core.Attribute;
import weka.core.AttributeStats;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;

/**
 *
 * @author sergio
 */
public class Tarea1 {

    public static void main(String[] args) throws Exception {

        String mainPath = "/home/sergio/MEGAsync/Trabajosfinales/MD/MD2/DataSets/DatasetsSiArff/";
        String path;
        int selectDataSet = 1;

        switch (selectDataSet) {

            case 1:
                path = mainPath + "wine.arff";
                break;

            case 2:
                path = mainPath + "SegmentationTrain.arff";
                break;

            default:
                path = mainPath + "wine.arff";
                break;

        }
        /*Construccion del DataSet*/
        DataSource fuente = new DataSource(path);
        Instances dataSet = fuente.getDataSet();
        dataSet.setClassIndex(0);

        /*Informacion del DataSet*/
        setInformation(dataSet);
        /*Informacion de cada atributo*/
        int selectAttribute = 0;
        attributeInformation(dataSet, selectAttribute);

    }

    private static void setInformation(Instances dataSet) throws Exception {

        /*Datos del conjunto*/
        System.out.println("Conjunto de datos " + dataSet.relationName());
        System.out.println("Numero de muestras " + dataSet.numInstances());
        System.out.println("Numero de atributos " + dataSet.numAttributes());
        System.out.println("La clase tiene  " + dataSet.numClasses() + " valores diferentes");

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

