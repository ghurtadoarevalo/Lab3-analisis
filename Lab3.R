# Librer�a para leer los datos
library(tidyr)

# Librer�a para graficar
library(ggplot2)

# Librer�a para la moda
library(modeest)

#Librer�a de reglas
library(arulesViz)

library("ggpubr")
library("cowplot")

cat(" =============================== Laboratorio N�2 An�lisis de Datos =============================== \n\n")
cat(" Desarrolladores: Patricia Melo - Gustavo Hurtado\n\n")


#===================================================== Lectura y manejo de BD =====================================================# 


# URL de la base de datos
url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/thyroid-disease/allhyper.data"

# Se leen los datos de la DB y se almacenan en data
data <- read.table(url, sep = "\t", dec = ",")

col_names <- c("age","sex","on_thyroxine","query_on_thyroxine","on_antithyroid_medication","sick","pregnant","thyroid_surgery",
               "I131_treatment","query_hypothyroid","query_hyperthyroid","lithium","goitre","tumor","hypopituitary", "psych",
               "TSH_measured", "TSH","T3_measured","T3","TT4_measured","TT4","T4U_measured","T4U","FTI_measured","FTI","TBG_measured",
               "TBG","referral_source","class")

# Se le asignan nombres apropiados a las columnas de los datos  
sep_data <- separate(data, col = "V1", into = col_names, sep = ",")

#======================================================== Funciones =========================================================#


# Se genera una funci�n que calcula la media, mediana, moda, desviaci�n standard, m�nimo y m�ximo 
# de una columna perteneciente a un data frame.
# Recibe una columna de un data frame y el nombre de la columna.
# Retorna un data frame con la media, mediana, moda, m�nimo, m�ximo y desviaci�n standard de la columna.
get_col_measures <- function(col, name){
  measurements <- data.frame(
    mean = round(mean(col, na.rm = TRUE),3),
    median = round(median(col, na.rm = TRUE),3),
    mode = round(mfv1(col, na_rm = TRUE),3),
    min = round(min(col, na.rm = TRUE),3),
    max = round(max(col, na.rm = TRUE),3),
    sd = round(sd(col, na.rm = TRUE),3)
  )
  rownames(measurements) <- c(name)
  
  return(measurements)
  
}


# Se genera una funci�n que calcula la media, mediana, moda y desviaci�n standard de todas las columnas de un
# data frame con valores num�ricos cont�nuos
# Recibe un data frame.
# Retorna un data frame con la media, mediana, moda y desviaci�n standard de cada columna del data frame.
get_all_measures <- function(data_frame){
  total_measurements <- rbind(get_col_measures(data_frame$age,"age"), get_col_measures(data_frame$TSH, "TSH"))
  total_measurements <- rbind(total_measurements, get_col_measures(data_frame$T3, "T3"))
  total_measurements <- rbind(total_measurements, get_col_measures(data_frame$TT4, "TT4"))
  total_measurements <- rbind(total_measurements, get_col_measures(data_frame$T4U, "T4U"))
  total_measurements <- rbind(total_measurements, get_col_measures(data_frame$FTI, "FTI"))
  return(total_measurements)
}


# Funci�n que calcula las frecuencias de las clases.
# Recibe la columna que contiene las clases.
# Retorna un data frame con las frecuencias de las clases.
class_frequency <- function(col, name){
  frequencies <- data.frame(
    Negative = NROW(subset(col, col == 'negative')),
    T3_toxic = NROW(subset(col, col == "T3 toxic")), 
    Goitre = NROW(subset(col, col == "goitre")), 
    Hyperthyroid = NROW(subset(col, col == "hyperthyroid"))
  )
  rownames(frequencies) <- c(name)
  return(frequencies)
}


# Funci�n que calcula las fecuencias de clases en los primeros 4 cluster.
# Recibe un dta frame.
# Retorna un data frame con las fecuencias de las clases en los primeros 4 cluster.
class_in_cluster_frequency <- function(data){
  frecuencies <- rbind(class_frequency(filter(data[21], data[22]==1), "1"))
  frecuencies <- rbind(frecuencies, class_frequency(filter(data[21], data[22]==2), "2"))
  frecuencies <- rbind(frecuencies, class_frequency(filter(data[21], data[22]==3), "3"))
  frecuencies <- rbind(frecuencies, class_frequency(filter(data[21], data[22]==4), "4"))
  return(frecuencies)
}


# Funci�n que calcula la frecuencia de una columna perteneciente a un data frame.
# Recibe una columna de un data frame y el nombre de la columna.
# Retorna un data frame con la frecuencia de true y false que se encuentran en la columna.
get_col_frequency <- function(col, name){
  frequencies <- data.frame(
    True = NROW(subset(col, col == "t")),
    False = NROW(subset(col, col == "f"))
  )
  rownames(frequencies) <- c(name)
  return(frequencies)
}


# Funci�n que calcula la frecuencia de todas las columnas de un data frame con variables discretas.
# Recibe un data frame.
# Retorna un data frame con las frecuencias de true y false de cada columna del data frame.
get_all_frequency <- function(data_frame){
  total_frequency <- rbind(get_col_frequency(data_frame$on_thyroxine, "on_thyroxine"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$query_on_thyroxine, "query_on_thyroxine"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$on_antithyroid_medication, "on_antithyroid_medication"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$sick, "sick"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$pregnant, "pregnant"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$thyroid_surgery, "thyroid_surgery"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$I131_treatment, "I131_treatment"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$query_hypothyroid, "query_hypothyroid"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$query_hyperthyroid, "query_hyperthyroid"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$lithium, "lithium"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$goitre, "goitre"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$tumor, "tumor"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$hypopituitary, "hypopituitary"))
  total_frequency <- rbind(total_frequency, get_col_frequency(data_frame$psych, "psych"))
  return(total_frequency)
}


# Funci�n que genera un dataframe con todos los valores normalizados.
# Recibe una columna del data frame.
# Entrega un data frame con los valores normalizados de la columna.
normalize <- function(col, name){
  max = max(col)
  min = min(col)
  data_normalized <- data.frame(
    value = ((col-min)/(max-min))
  )
  colnames(data_normalized) <- name
  return(data_normalized)
}

# Funci�n que genera un dataframe con todos los valores normalizados de un data frame.
# Recibe un data frame.
# Entrega un data frame con los valores normalizados de todas las columnas.
normalize_all <- function(data_frame){
  data_final <- cbind(normalize(data_frame$age, "age"))
  data_final <- cbind(data_final, normalize(data_frame$sex, "sex"))
  data_final <- cbind(data_final, normalize(data_frame$on_thyroxine, "on_thyroxine"))
  data_final <- cbind(data_final, normalize(data_frame$query_on_thyroxine, "query_on_thyroxine"))
  data_final <- cbind(data_final, normalize(data_frame$on_antithyroid_medication, "on_antithyroid_medication"))
  data_final <- cbind(data_final, normalize(data_frame$sick, "sick"))
  data_final <- cbind(data_final, normalize(data_frame$pregnant, "pregnant"))
  data_final <- cbind(data_final, normalize(data_frame$thyroid_surgery, "thyroid_surgery"))
  data_final <- cbind(data_final, normalize(data_frame$I131_treatment, "I131_treatment"))
  data_final <- cbind(data_final, normalize(data_frame$query_hypothyroid, "query_hypothyroid"))
  data_final <- cbind(data_final, normalize(data_frame$query_hyperthyroid, "query_hyperthyroid"))
  data_final <- cbind(data_final, normalize(data_frame$lithium, "lithium"))
  data_final <- cbind(data_final, normalize(data_frame$goitre, "goitre"))
  data_final <- cbind(data_final, normalize(data_frame$tumor, "tumor"))
  data_final <- cbind(data_final, normalize(data_frame$psych, "psych"))
  data_final <- cbind(data_final, normalize(data_frame$TSH, "TSH"))
  data_final <- cbind(data_final, normalize(data_frame$T3, "T3"))
  data_final <- cbind(data_final, normalize(data_frame$TT4, "TT4"))
  data_final <- cbind(data_final, normalize(data_frame$T4U, "T4U"))
  data_final <- cbind(data_final, normalize(data_frame$FTI, "FTI"))
  return(data_final)
}


#======================================= Reconocimiento de datos ==========================================

# Se calcula datos de medida central para cada variable num�rica, antes de la limpieza
# Para esto no se consideran los datos nulos y se crea un data frame para luego utilizar una funci�n.

# Edad
age <- sep_data$age
age[age == "?"] <- NA
age <- as.numeric(as.character(age))

# TSH
tsh <- sep_data$TSH
tsh[tsh == "?"] <- NA
tsh <- as.numeric(as.character(tsh))

# T3
t3 <- sep_data$T3
t3[t3 =="?"] <- NA
t3 <- as.numeric(as.character(t3))

# TT4
tt4 <- sep_data$TT4
tt4[tt4 =="?"] <- NA
tt4 <- as.numeric((as.character(tt4)))

# T4U
t4u <- sep_data$T4U
t4u[t4u =="?"] <- NA
t4u <- as.numeric(as.character(t4u))

# FTI
fti <- sep_data$FTI
fti[fti == "?"]<-NA
fti <- as.numeric(as.character(fti))


# Se crea el data frame.
datos <- data.frame(
  "age" = age,
  "TSH" = tsh, 
  "T3" = t3,
  "TT4" = tt4,
  "T4U" = t4u, 
  "FTI" = fti
)

# Se calcula la media, mediana, moda, m�nimo, m�ximo y desviaci�n est�ndar
get_all_measures(datos)

# Para variables categ�ricas se procede a calcular la frecuencia en cada caso
# Se tiene para sexo: F, M.
# Resto de variables categ�ricas: t, f.

# data frame con variables cualitativas 
data_cualitative <- data.frame(
  "on_thyroxine" = sep_data$on_thyroxine,
  "query_on_thyroxine" = sep_data$query_on_thyroxine,
  "on_antithyroid_medication" = sep_data$on_antithyroid_medication,
  "sick" = sep_data$sick,
  "pregnant" = sep_data$pregnant,
  "thyroid_surgery" = sep_data$thyroid_surgery,
  "I131_treatment" = sep_data$I131_treatment,
  "query_hypothyroid" = sep_data$query_hypothyroid,
  "query_hyperthyroid" = sep_data$query_hyperthyroid,
  "lithium" = sep_data$lithium,
  "goitre" = sep_data$goitre,
  "tumor" = sep_data$tumor,
  "hypopituitary" = sep_data$hypopituitary, 
  "psych" = sep_data$psych
)


# Sexo
sex <- sep_data$sex
female_quant <- NROW(subset(sex, sex == "F"))
male_quant <- NROW(subset(sex, sex == "M"))

# Resto de las variables cualitativas
get_all_frequency(data_cualitative)


#====================== Detecci�n y tratamiento de datos faltantes y at�picos =======================#

# Se quitaron los n�meros al final de la clase (|.232), ya que no se utilizan.
sep_data$class <- vapply(strsplit(sep_data$class,"\\."), `[`, 1, FUN.VALUE=character(1))

# Se obtiene el n�mero total de individuos que se enceuntran en el estudio.
total_individuos <- nrow(sep_data)    # 2800

# Esta variable auxiliar guardar� los datos sin modificar
sep_data_aux <- sep_data


# -------------------------------------------------------------------
#                    Disminuci�n de variables 
#
# Se eliminan variables que no entregan un gran aporte al estudio

# Variables num�ricas:
# Dado que TGB medido es siempre falso, se quitar� la columna TBG
sep_data$TBG <- NULL

# Variables categ�ricas:
# Como se elimin� TBG, ya no es necesario TBG measured.
sep_data$TBG_measured <- NULL

# Adem�s, al tener valores en el resto de las variables num�ricas hace que todas las variables que tengan
# "measured" no entreguen mayor informaci�n, ya que si hay valor entonces el individuo se realiz� el examen.
sep_data$TSH_measured <- NULL
sep_data$T3_measured <- NULL
sep_data$TT4_measured <- NULL
sep_data$T4U_measured <- NULL
sep_data$FTI_measured <- NULL

# Con el reconocimiento de datos previamente hecho, se vi� que la variable hypopituitary no ten�a una
# gran variaci�n en los resultados, donde hab�a 1 verdadero y 2799 falsos, por este motivo se elimina.
sep_data$hypopituitary <- NULL

# Otras variables discretas que no entregan mayor informaci�n al estudio con respecto a los calculos son
# referral source y class, eliminando as� a ambas.
sep_data$referral_source<-NULL
#sep_data$class <- NULL

# -------------------------------------------------------------------
#             Uni�n de las clases con muy bajo % de representatividad


sep_data$class[sep_data$class == "T3 toxic"] <- "positive"
sep_data$class[sep_data$class == "goitre"] <- "positive"
sep_data$class[sep_data$class == "hyperthyroid"] <- "positive"



# -------------------------------------------------------------------
#             Detecci�n  y tratamiento de datos faltantes 
#
# Se encuentran los datos nulos y se ve si es posibles intercambiarlos por la mediana o moda

# Variables continuas:
# A continuaci�n se obtiene la cantidad de filas restantes que no contienen "?" (nulo)
# por cada variable n�merica encontrada.

# Edad
age <- age[complete.cases(age)]
rows_age <- NROW(age)             # = 2799
# TSH
tsh <- tsh[complete.cases(tsh)]
rows_tsh <- NROW(tsh)             # = 2516
# T3
t3 <- t3[complete.cases(t3)]
rows_t3 <- NROW(t3)               # = 2215
# TT4
tt4 <- tt4[complete.cases(tt4)]
rows_tt4 <- NROW(tt4)             # = 2616
# T4U
t4u <- t4u[complete.cases(t4u)]
rows_t4u <- NROW(t4u)             # = 2503
# FTI
fti <- fti[complete.cases(fti)]
rows_fti <- NROW(fti)             # = 2505

# Para poder reemplazar los datos faltantes por la media, mediana o moda es necesario que dichos datos sean 
# cercanos al 5% del total de la poblaci�n.
# 140 corresponde al 5% de 2800.

# Comparando los resultados de las filas reci�n obtenidas, se ve que ninguna variable cumple con dicho requisito, 
# por eso se decide eliminar las filas del que m�s p�rdida tiene, y as� volver a calcular.

# Eliminando "?" de T3
sep_data$T3[sep_data$T3 == "?"] <- NA

sep_data <- sep_data[complete.cases(sep_data),]

# Nuevo total de casos: 2215
# Probando con el resto de variables para ver si es cercano al 5% nuevo (110.75).

# Edad
age <- sep_data$age
age[age == "?"] <- NA
age <- age[complete.cases(age)]
rows_age <- NROW(age)             # = 2214

# TSH
tsh <- sep_data$TSH
tsh[tsh == "?"] <- NA
tsh <- tsh[complete.cases(tsh)]
rows_tsh <- NROW(tsh)             # = 2143

# TT4
tt4 <- sep_data$TT4
tt4[tt4 =="?"] <- NA
tt4 <- tt4[complete.cases(tt4)]
rows_tt4 <- NROW(tt4)             # = 2189

# T4U
t4u <- sep_data$T4U
t4u[t4u =="?"] <- NA
t4u <- t4u[complete.cases(t4u)]
rows_t4u <- NROW(t4u)             # = 2078    6,19%

# FTI
fti <- sep_data$FTI
fti[fti == "?"]<-NA
fti <- fti[complete.cases(fti)]
rows_fti <- NROW(fti)             # = 2080    6,09%


# Esta vez los datos si son cercanos al 5%, por lo que se procede a rellenar los datos nulos
# de cada variable con sus medianas.

# Edad
sep_data$age[sep_data$age == "?"] <- NA
sep_data$age <- as.numeric(as.character(sep_data$age))
sep_data$age[is.na(sep_data$age)] <- median(sep_data$age, na.rm = TRUE)

# TSH
sep_data$TSH[sep_data$tsh == "?"] <- NA
sep_data$TSH <- as.numeric(as.character(sep_data$TSH))
sep_data$TSH[is.na(sep_data$TSH)] <- median(sep_data$TSH, na.rm = TRUE)

# TT4
sep_data$TT4[sep_data$TT4 == "?"] <- NA
sep_data$TT4 <- as.numeric(as.character(sep_data$TT4))
sep_data$TT4[is.na(sep_data$TT4)] <- median(sep_data$TT4, na.rm = TRUE)

# T4U
sep_data$T4U[sep_data$T4U == "?"] <- NA
sep_data$T4U <- as.numeric(as.character(sep_data$T4U))
sep_data$T4U[is.na(sep_data$T4U)] <- median(sep_data$T4U, na.rm = TRUE)

# FTI
sep_data$FTI[sep_data$FTI == "?"] <- NA
sep_data$FTI <- as.numeric(as.character(sep_data$FTI))
sep_data$FTI[is.na(sep_data$FTI)] <- median(sep_data$FTI, na.rm = TRUE)

# T3
sep_data$T3[sep_data$T3 == "?"] <- NA
sep_data$T3 <- as.numeric(as.character(sep_data$T3))
sep_data$T3[is.na(sep_data$T3)] <- median(sep_data$T3, na.rm = TRUE)


# Variables discretas:
# La �nica variable que contiene datos nulos es sexo, por lo que se procede a rellenar con la moda, 
# la cual es femenino.
sep_data$sex[sep_data$sex == "?"] <- "F"


# -------------------------------------------------------------------
#             Detecci�n y tratamiento de datos at�picos 
#
# Los datos que esten fuera de un rango determinado ser�n considerados como at�picos y se procederan a 
# intercambiar por la mediana

# Variables continuas:
sep_data$age[sep_data$age > 110] <- median(sep_data$age)
sep_data$TSH[sep_data$TSH > 10] <- median(sep_data$TSH)
sep_data$T3[sep_data$T3 > 5] <- median(sep_data$T3)
sep_data$TT4[sep_data$TT4 > 220] <- median(sep_data$TT4)
sep_data$FTI[sep_data$FTI > 200] <- median(sep_data$FTI)


#Se dejan todas las variables discretas como factores

sep_data_factors <- sep_data
sep_data_factors$sex <- as.factor(sep_data_factors$sex)
sep_data_factors$on_thyroxine <- as.factor(sep_data_factors$on_thyroxine)
sep_data_factors$query_on_thyroxine <- as.factor(sep_data_factors$query_on_thyroxine)
sep_data_factors$on_antithyroid_medication <- as.factor(sep_data_factors$on_antithyroid_medication)
sep_data_factors$sick <- as.factor(sep_data_factors$sick)
sep_data_factors$pregnant <- as.factor(sep_data_factors$pregnant)
sep_data_factors$thyroid_surgery <- as.factor(sep_data_factors$thyroid_surgery)
sep_data_factors$I131_treatment <- as.factor(sep_data_factors$I131_treatment)
sep_data_factors$query_hypothyroid <- as.factor(sep_data_factors$query_hypothyroid)
sep_data_factors$query_hyperthyroid <- as.factor(sep_data_factors$query_hyperthyroid)
sep_data_factors$lithium <- as.factor(sep_data_factors$lithium)
sep_data_factors$goitre <- as.factor(sep_data_factors$goitre)
sep_data_factors$tumor <- as.factor(sep_data_factors$tumor)
sep_data_factors$psych <- as.factor(sep_data_factors$psych)
sep_data_factors$class <- as.factor(sep_data_factors$class)


# -------------------------------------------------------------------
#             Discretizaci�n de los datos

age = c(0,11,26,59,Inf)
age.names = c("Infancy","Youth","Adulthood","Eld")

TSH = c(-Inf, 0.4, 4.5, Inf)
TSH.names = c("Low","Normal","High")

T3 = c(-Inf, 0.92, 2.76, Inf)
T3.names = c("Low","Normal","High")

TT4 = c(-Inf, 54, 115, Inf)
TT4.names = c("Low","Normal","High")

T4U = c(-Inf, 0.71, 1.85, Inf)
T4U.names = c("Low","Normal","High")

FTI = c(-Inf, 45, 117, Inf)
FTI.names = c("Low","Normal","High")


sep_data_factors$age = cut(sep_data_factors$age, breaks = age, labels = age.names)
sep_data_factors$TSH = cut(sep_data_factors$TSH, breaks = TSH, labels = TSH.names)
sep_data_factors$T3 =  cut(sep_data_factors$T3, breaks = T3, labels = T3.names)
sep_data_factors$TT4 = cut(sep_data_factors$TT4, breaks = TT4, labels = TT4.names)
sep_data_factors$T4U = cut(sep_data_factors$T4U, breaks = T4U, labels = T4U.names)
sep_data_factors$FTI = cut(sep_data_factors$FTI, breaks = FTI, labels = FTI.names)

# -------------------------------------------------------------------
#                           Reglas 

# ------------------ Reglas para clase positiva --------------------- 
# Soporte: 0.01, confidence: 0.2 , Tiempo de procesamiento m�x 300 [s]
positive_rules = apriori(
  data = sep_data_factors,
  parameter=list(support = 0.01,confidence = 0.2,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("class=positive"))
)

#Se obtiene la regla con mayor confianza
sorted_positive_rules_confidence <- sort(x = positive_rules, decreasing = TRUE, by = "confidence")[1]
#Se obtiene la regla con mayor soporte
sorted_positive_rules_support <- sort(x = positive_rules, decreasing = TRUE, by = "support")[1]
#Se obtiene la regla con mayor lift
sorted_positive_rules_lift <- sort(x = positive_rules, decreasing = TRUE, by = "lift")[1]


#Se muestran la regla con mayor confianza
inspect(sorted_positive_rules_confidence)
#Se muestran la regla con mayor soporte
inspect(sorted_positive_rules_support)
#Se muestran la regla con mayor lift
inspect(sorted_positive_rules_lift)

# ------------------ Reglas para clase negativa  --------------------
# Soporte: 0.8, Tiempo de procesamiento m�x 5 [s]
negative_rules = apriori(
  data = sep_data_factors,
  parameter=list(support = 0.8, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("class=negative"))
  
)

#Se ordenan las reglas almacenando las 5 con mayor lift
sorted_negative_rules_decreasing_lift <- sort(x = negative_rules, decreasing = TRUE, by = "lift")[1:5]
#Se ordenan las reglas almacenando las 5 con menor lift
sorted_negative_rules_increasing_lift <- sort(x = negative_rules, decreasing = FALSE, by = "lift")[1:5]

#Se muestran las 5 reglas con mayor lift
inspect(sorted_negative_rules_decreasing_lift)
#Se muestran las 5 reglas con menor lift
inspect(sorted_negative_rules_increasing_lift)


# ------------------ Reglas para TSH  --------------------

############# TSH = Low ############ 
# Soporte: 0.001, Tiempo de procesamiento m�x 300 [s]
low_TSH_rules = apriori(
  data = sep_data_factors[1:20],
  parameter=list(support = 0.001,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("TSH=Low"))
)

#Se ordenan las reglas almacenando las 5 con mayor lift
sorted_low_TSH_rules_lift <- sort(x = low_TSH_rules, decreasing = TRUE, by = "lift")[2:4]
#Se ordenan las reglas almacenando las 5 con mayor soporte
sorted_low_TSH_rules_support <- sort(x = low_TSH_rules, decreasing = TRUE, by = "support")[1]

#Se muestran las 5 reglas con mayor lift
inspect(sorted_low_TSH_rules_lift)
#Se muestran las 5 reglas con mayor soporte
inspect(sorted_low_TSH_rules_support)

############ TSH = High ############ 
# Soporte: 0.001, Tiempo de procesamiento m�x 300 [s]
high_TSH_rules = apriori(
  data = sep_data_factors[1:20],
  parameter=list(support = 0.001,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("TSH=High"))
)

#Se ordenan las reglas almacenando la con mayor lift
sorted_high_TSH_rules_lift <- sort(x = high_TSH_rules, decreasing = TRUE, by = "lift")[1]
#Se ordenan las reglas almacenando la con mayor soporte
sorted_high_TSH_rules_support <- sort(x = high_TSH_rules, decreasing = TRUE, by = "support")[1]

#Se muestran la regla con mayor lift
inspect(sorted_high_TSH_rules_lift)
#Se muestran la regla con mayor soporte
inspect(sorted_high_TSH_rules_support)

############ TSH = Normal ############ 
# Soporte: 0.2, Tiempo de procesamiento m�x 300 [s]
# normal_TSH_rules = apriori(
#   data = sep_data_factors[1:20],
#   parameter=list(support = 0.2,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
#   appearance=list(rhs = c("TSH=Normal"))
# )
# 
# #Se ordenan las reglas almacenando la con mayor lift
# sorted_normal_TSH_rules_lift <- sort(x = normal_TSH_rules, decreasing = TRUE, by = "lift")[1]
# #Se ordenan las reglas almacenando la con mayor soporte
# sorted_normal_TSH_rules_support <- sort(x = normal_TSH_rules, decreasing = TRUE, by = "support")[1]
# 
# #Se muestran la regla con mayor lift
# inspect(sorted_normal_TSH_rules_lift)
# #Se muestran la regla con mayor soporte
# inspect(sorted_normal_TSH_rules_support)


# ------------------ Reglas para Edad  --------------------
# Soporte: 0.01, Tiempo de procesamiento m�x 300 [s]
age_rules = apriori(
  data = sep_data_factors[1:20],
  parameter=list(support = 0.01,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("age=Eld","age=Adulthood","age=Youth","age=Infancy"))
)

#No existen reglas con soporte min de 0.01 y confianza min de 0.8,para infancia ni juventud

#Se ordenan las reglas almacenando la con mayor lift
sorted_eld_age_rules_lift <- sort(x = subset(x = age_rules, rhs %ain% c("age=Eld")), decreasing = TRUE, by = "lift")[1]
sorted_adulthood_age_rules_lift <- sort(x = subset(x = age_rules, rhs %ain% c("age=Adulthood")), decreasing = TRUE, by = "lift")[1]
#Se ordenan las reglas almacenando la con mayor confianza
sorted_eld_age_rules_confidence <- sort(x = subset(x = age_rules, rhs %ain% c("age=Eld")), decreasing = TRUE, by = "confidence")[1]
sorted_adulthood_age_rules_confidence <- sort(x = subset(x = age_rules, rhs %ain% c("age=Adulthood")), decreasing = TRUE, by = "confidence")[1]
#Se ordenan las reglas almacenando la con mayor soporte
sorted_eld_age_rules_support <- sort(x = subset(x = age_rules, rhs %ain% c("age=Eld")), decreasing = TRUE, by = "support")[1]
sorted_adulthood_age_rules_support <- sort(x = subset(x = age_rules, rhs %ain% c("age=Adulthood")), decreasing = TRUE, by = "support")[2]

#Se muestra la regla con mayor lift
inspect(sorted_eld_age_rules_lift)
inspect(sorted_adulthood_age_rules_lift)
#Se muestra la regla con mayor confianza
inspect(sorted_eld_age_rules_confidence)
inspect(sorted_adulthood_age_rules_confidence)
#Se muestra la regla con mayor soporte
inspect(sorted_eld_age_rules_support)
inspect(sorted_adulthood_age_rules_support)

# ------------------ Reglas hormonas  --------------------
# Soporte: 0.01, Tiempo de procesamiento m�x 300 [s]
hormones_rules = apriori(
  data = sep_data_factors[1:20],
  parameter=list(support = 0.01,maxtime = 300, minlen = 3, maxlen = 20, target="rules"),
  appearance=list(rhs = c("T4U=Low","T4U=High","T3=Low","T3=High","TT4=Low","TT4=High","FTI=Low","FTI=High"))
)

#Se ordenan las reglas almacenando la con mayor lift
sorted_hormones_rules_lift <- sort(x = hormones_rules , decreasing = TRUE, by = "lift")[2]
#Se ordenan las reglas almacenando la con mayor soporte
sorted_hormones_rules_support <- sort(x = hormones_rules , decreasing = TRUE, by = "support")[1]
#Se ordenan las reglas almacenando la con mayor confianza
sorted_hormones_rules_confidence <- sort(x = hormones_rules , decreasing = TRUE, by = "confidence")[2]


#Se muestra la regla con mayor lift
inspect(sorted_hormones_rules_lift)
#Se muestra la regla con mayor soporte
inspect(sorted_hormones_rules_support)
#Se muestra la regla con mayor confianza
inspect(sorted_hormones_rules_confidence)

# boxplot.age =  ggboxplot(data =sep_data, x = "class", y = "age", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.age, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.age = insert_yaxis_grob(boxplot.age, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.age)
# 
# boxplot.sex =  ggboxplot(data =sep_data, x = "class", y = "sex", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.sex, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.sex = insert_yaxis_grob(boxplot.sex, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.sex)
# 
# boxplot.TSH =  ggboxplot(data =sep_data, x = "class", y = "TSH", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.TSH, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.TSH = insert_yaxis_grob(boxplot.TSH, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.TSH)
# 
# boxplot.T4U =  ggboxplot(data =sep_data, x = "class", y = "T4U", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.T4U, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.T4U = insert_yaxis_grob(boxplot.T4U, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.T4U)
# 
# boxplot.T3 =  ggboxplot(data =sep_data, x = "class", y = "T3", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.T3, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.T3 = insert_yaxis_grob(boxplot.T3, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.T3)
# 
# boxplot.FTI =  ggboxplot(data =sep_data, x = "class", y = "FTI", color = "class", add = "jitter") + border() 
# ydens = axis_canvas(boxplot.FTI, axis = "y", coord_flip = TRUE) + geom_density(data = sep_data, aes(x = area, fill = class), alpha = 0.7, size = 0.2) + coord_flip()
# boxplot.FTI = insert_yaxis_grob(boxplot.FTI, ydens, grid::unit(.2, "null"), position = "right")
# ggdraw(boxplot.FTI)

#[1] {query_on_thyroxine=f,TSH=Low} => {class=negative} 0.2004515 0.8809524  0.2275395 0.908854 444  

