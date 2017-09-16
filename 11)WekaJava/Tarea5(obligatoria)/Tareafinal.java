/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package holdoutandbootsrap;

import java.util.ArrayList;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.BayesNet;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.classifiers.lazy.IBk;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.instance.Randomize;
import weka.core.converters.ConverterUtils.DataSource;
import weka.filters.unsupervised.instance.Resample;

/**
 *
 * @author sergio
 */
public class HoldoutAndBootsrap {

    /**
     * @param args the command line arguments
     * @throws java.lang.Exception
     */
    public static void main(String[] args) throws Exception {

        /* DataSets*/
        String path = "/home/sergio/MEGAsync/Trabajosfinales/MD/MD2/DataSets/DatasetsSiArff/wine.arff";
        DataSource fuente = new DataSource(path);
        Instances dataSet = fuente.getDataSet();
        dataSet.setClassIndex(0);

        /* Algunos clasificadores */
        int selectClasificador = 1;
        Classifier clasificador;
        switch (selectClasificador) {
            case 1:
                clasificador = arbol();
                break;
            case 2:
                int k = 3;
                clasificador = KNN(k);
                break;
            case 3:
                clasificador = bayes();
                break;
            case 4:
                clasificador = perceptron();
                break;
            default : 
                clasificador = arbol();
                break;
        }

	/* Implementacion de funciones */
        
        /*Funcion BootsTrap*/

        int B = 20;
        double tasadeAciertoBootstrap = Bootstrap(clasificador, dataSet, B);
        System.out.println("tasadeAciertoBootstrap=" + tasadeAciertoBootstrap);
        
         
        /*Funcion HoldOut*/        
        double trainPercentage = 66;
        boolean correccion = true;
        double tasadeAciertoHoldout = Holdout(clasificador, dataSet, trainPercentage, correccion);

        String stringtHoldOut=(correccion)? "tasadeAciertoHoldOut corregida=":"tasadeAciertoHoldOut=";
        System.out.println(stringtHoldOut + tasadeAciertoHoldout);
       
  
      
    }
    
    
    

    private static double Bootstrap(Classifier clasificador, Instances dataSet, int B) throws Exception {
        double errorSum = 0.0;
        ArrayList BdataSets = new ArrayList();

        for (int i = 0; i < B; i++) {

            errorSum += TrainAndEvaluate(clasificador, resampling(dataSet, i + 1), dataSet);

        }

        double errorMedio = errorSum / B;
        double resultado = 1 - errorMedio;

        return resultado;

    }

    private static double Holdout(Classifier clasificador, Instances dataSet, double trainPercentage, boolean correccion) throws Exception {

        /*Separamos conjunto de datos*/
        ArrayList splitDataSet = splitDataSet(dataSet, trainPercentage);
        Instances datosTrain = (Instances) splitDataSet.get(0);
        Instances datosTest = (Instances) splitDataSet.get(1);

        /*Entrenamos y evaluamos*/
        double errorHoldout = TrainAndEvaluate(clasificador, datosTrain, datosTest);
        double resultado = 1 - errorHoldout;

        if (correccion) {

            double errorN = TrainAndEvaluate(clasificador, datosTrain, dataSet);
            double errorRestitucion = TrainAndEvaluate(clasificador, dataSet, dataSet);
            double errorCorregido = errorHoldout + errorRestitucion - errorN;
            double resultadoCorregido = 1 - errorCorregido;

            return resultadoCorregido;

        } else {

            return resultado;

        }

    }

    private static Instances randomize(Instances dataSet) throws Exception {

        Randomize toRandom = new Randomize();
        String opcion[] = weka.core.Utils.splitOptions("-S 42");
        toRandom.setOptions(opcion);
        toRandom.setInputFormat(dataSet);
        Instances randomDates = Filter.useFilter(dataSet, toRandom);

        return randomDates;
    }

    private static Instances resampling(Instances dataSet, int seed) throws Exception {

        Resample toResample = new Resample();
        String stringOption = "-S " + seed + " -Z 100";
        String opcion[] = weka.core.Utils.splitOptions(stringOption);
        toResample.setOptions(opcion);
        toResample.setInputFormat(dataSet);
        Instances resampleDates = Filter.useFilter(dataSet, toResample);

        return resampleDates;
    }

    private static ArrayList splitDataSet(Instances dataSet, double trainPercentage) throws Exception {


        /*Aleatorizamos el conjunto de datos*/
        Instances randomDataSet = randomize(dataSet);
        /*Se calcula el numero de muestras */
        int num2Train = (int) Math.round(dataSet.numInstances() * trainPercentage / 100);
        int num2Test = dataSet.numInstances() - num2Train;
        /*Se generan los dos subconjuntos*/
        Instances datosTrain = new Instances(randomDataSet, 0, num2Train);
        Instances datosTest = new Instances(randomDataSet, num2Train, num2Test);
        /*Cargamos los datos en un ArrayList para su retorno*/
        ArrayList splitDataSet = new ArrayList();
        splitDataSet.add(datosTrain);
        splitDataSet.add(datosTest);

        return splitDataSet;

    }

    private static double TrainAndEvaluate(Classifier clasificador, Instances datosTrain, Instances datosTest) throws Exception {

        clasificador.buildClassifier(datosTrain);
        Evaluation eval = new Evaluation(datosTest);
        eval.evaluateModel(clasificador, datosTest);
        double error = eval.errorRate();
        return error;

    }



    /*Algunos clasificadores*/
    private static J48 arbol() throws Exception {

        J48 clasificador = new J48();
        String[] options = weka.core.Utils.splitOptions("-C 0.25 -M 2");
        clasificador.setOptions(options);
        return clasificador;
    }

    private static BayesNet bayes() throws Exception {
        BayesNet clasificador = new BayesNet();
        String[] options = weka.core.Utils.splitOptions("");
        clasificador.setOptions(options);
        return clasificador;
    }

    private static IBk KNN(int k) throws Exception {

        // Modulo de contruccion del clasificador
        IBk clasificador = new IBk();
        String[] options = weka.core.Utils.splitOptions("-K " + k + " -W 0");
        clasificador.setOptions(options);
        return clasificador;

    }

    private static MultilayerPerceptron perceptron() throws Exception {

        MultilayerPerceptron clasificador = new MultilayerPerceptron();
        String[] options = weka.core.Utils.splitOptions("-L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H a");
        clasificador.setOptions(options);
        return clasificador;

    }
}

