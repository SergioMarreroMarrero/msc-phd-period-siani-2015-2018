/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tarea4;

import java.util.ArrayList;
import java.util.Scanner;
import weka.attributeSelection.AttributeSelection;
import weka.attributeSelection.InfoGainAttributeEval;
import weka.attributeSelection.Ranker;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.BayesNet;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.classifiers.lazy.IBk;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;
import weka.filters.Filter;
import weka.filters.unsupervised.instance.Randomize;

/**
 *
 * @author sergio
 */
public class Tarea4 {

    /**
     * @param args the command line arguments
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

        int numAttri = 5;
        ArrayList subDataSet = SeleccionAtributos(dataTrain, dataTest, numAttri);
        Instances subDataTrain = (Instances) subDataSet.get(0);
        Instances subDataTest = (Instances) subDataSet.get(1);

        // Activamos los distintos clasificadores
        EntrenaBayesiano(subDataTrain, subDataTest);
        int k = 5;
        EntrenaKNN(subDataTrain, subDataTest, k); // Elegir entre k=1,5,10
        EntrenaPerceptron(subDataTrain, subDataTest);
    }

    private static Instances loadData(String path, int clase) throws Exception {

        ConverterUtils.DataSource fuente = new ConverterUtils.DataSource(path);
        Instances dataSet = fuente.getDataSet();
        dataSet.setClassIndex(clase);

        return dataSet;

    }

    private static Instances Aleatorizar(Instances datos) throws Exception {
        Randomize toRandom = new Randomize();
        String opcion[] = weka.core.Utils.splitOptions("-S 42");
        toRandom.setOptions(opcion);
        toRandom.setInputFormat(datos);
        Instances randomDates = Filter.useFilter(datos, toRandom);

        return randomDates;
    }

    private static ArrayList SeleccionAtributos(Instances datosTrain, Instances datosTest, int numAttri) throws Exception {

        //Construccion del selector de atributos
        AttributeSelection attsel = new AttributeSelection();
        InfoGainAttributeEval eval = new InfoGainAttributeEval();
        attsel.setEvaluator(eval);
        Ranker search = new Ranker();

        // Reduccion de la dimensionalidad
        String[] options = weka.core.Utils.splitOptions("-T -1.7976931348623157E308 -N " + numAttri + " -num-slots 1");
        search.setOptions(options);
        attsel.setSearch(search);

        // Seleccionamos los atributos
        attsel.SelectAttributes(datosTrain);

        Instances subDatosTrain = attsel.reduceDimensionality(datosTrain);
        Instances subDatosTest = attsel.reduceDimensionality(datosTest);

        ArrayList subDataSet = new ArrayList();
        subDataSet.add(subDatosTrain);
        subDataSet.add(subDatosTest);

        return subDataSet;

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

}

