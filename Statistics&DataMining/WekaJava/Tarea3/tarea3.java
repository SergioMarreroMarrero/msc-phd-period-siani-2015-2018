/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tarea3;

import java.util.Scanner;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.BayesNet;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.classifiers.lazy.IBk;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;
import weka.core.converters.ConverterUtils.DataSource;

/**
 *
 * @author sergio
 */
public class Tarea3 {

    /**
     * @param args the command line arguments
     * @throws java.lang.Exception
     */
    public static void main(String[] args) throws Exception {

        // Cargamos conjunto de datos de Entrenamiento.
        String mainPath = "/home/sergio/MEGAsync/Trabajosfinales/MD/MD2/DataSets/DatasetsSiArff/";
        String path;
        int clase = 0;
        //Train
        path = mainPath + "SegmentationTrain.arff";
        Instances dataTrain = loadData(path, clase);
        //Test    
        path = mainPath + "SegmentationTest.arff";
        Instances dataTest = loadData(path, clase);

        // Activamos los distintos clasificadores
        int k = 3; // vecinos mas cercanos
        EntrenaKNN(dataTrain, dataTest, k);

        EntrenaArbol(dataTrain, dataTest);

        EntrenaBayesiano(dataTrain, dataTest);

        EntrenaPerceptron(dataTrain, dataTest);

    }

    private static Instances loadData(String path, int clase) throws Exception {

        DataSource fuente = new ConverterUtils.DataSource(path);
        Instances dataSet = fuente.getDataSet();
        dataSet.setClassIndex(clase);

        return dataSet;

    }

    private static void evaluationVisulization(Classifier clasificador, Instances datosTrain, Instances datosTest) throws Exception {

        // Modulo de evaluacion
        Evaluation eval = new Evaluation(datosTrain);
        eval.evaluateModel(clasificador, datosTest);

        // Modulo de visualizacion
        System.out.println("\n**************************SUMMARY************************************************\n");
        System.out.print(eval.toSummaryString());
        System.out.println("\n\n\n**************************CONFUSION MATRIX************************************************\n");
        System.out.print(eval.toMatrixString());
    }

    // Bayesiano
    private static void EntrenaBayesiano(Instances datosTrain, Instances datosTest) throws Exception {
        System.out.println("**************************INICIO BAYESIANO************************************************");
        // Modulo de construccion del clasificador
        BayesNet clasificador = new BayesNet();
        String[] options = weka.core.Utils.splitOptions("");
        clasificador.setOptions(options);
        clasificador.buildClassifier(datosTrain);
        /*Evaluacion y visualizacion*/
        evaluationVisulization(clasificador, datosTrain, datosTest);
        System.out.println("\n\n\n**************************FIN BAYESIANO************************************************\n\n\n");
    }

    private static void EntrenaArbol(Instances datosTrain, Instances datosTest) throws Exception {
        System.out.println("**************************INICIO ARBOL************************************************");

        // Modulo de contruccion del clasificador
        J48 clasificador = new J48();
        String[] options = weka.core.Utils.splitOptions("-C 0.25 -M 2");
        clasificador.setOptions(options);
        clasificador.buildClassifier(datosTrain);

        /*Evaluacion y visualizacion*/
        evaluationVisulization(clasificador, datosTrain, datosTest);
        System.out.println("\n\n\n**************************FIN ARBOL************************************************\n\n\n");
    }

    // K-nn
    private static void EntrenaKNN(Instances datosTrain, Instances datosTest, int k) throws Exception {
        System.out.println("**************************INICIO KNN************************************************");
        // Modulo de contruccion del clasificador
        IBk clasificador = new IBk();
        String[] options = weka.core.Utils.splitOptions("-K " + k + " -W 0");
        clasificador.setOptions(options);
        clasificador.buildClassifier(datosTrain);
        /*Evaluacion y visualizacion*/
        evaluationVisulization(clasificador, datosTrain, datosTest);
        System.out.println("\n\n\n**************************FIN VECINOS************************************************\n\n\n");
    }

    private static void EntrenaPerceptron(Instances datosTrain, Instances datosTest) throws Exception {
        System.out.println("**************************INICIO PERCEPTRON************************************************");
        // Modulo de contruccion del clasificador
        MultilayerPerceptron clasificador = new MultilayerPerceptron();
        String[] options = weka.core.Utils.splitOptions("-L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a");
        clasificador.setOptions(options);
        clasificador.buildClassifier(datosTrain);
        /*Evaluacion y visualizacion*/
        evaluationVisulization(clasificador, datosTrain, datosTest);
        System.out.println("\n\n\n**************************FIN PERCEPTRON************************************************\n\n\n");

    }

}

