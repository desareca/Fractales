#solucion problema paquetes BioConductor
suppressMessages(library(BiocManager))
options(repos = BiocManager::repositories())
getOption("repos")
# load Libraries
suppressMessages(library(shiny))
suppressMessages(library(shinyjs))
suppressMessages(library(shinythemes))
suppressMessages(library(EBImage))
suppressMessages(library(RColorBrewer))
# Define interface required to predict next word
shinyUI(navbarPage("Fractales", 
                   theme = shinytheme("slate"),
                   tabPanel("Generador de Fractales",
                            shinyUI(fluidPage(
                                  theme = shinytheme("slate"),
                                  sidebarLayout(
                                        sidebarPanel(width = 2, 
                                              HTML("<span style='color:white'>"),
                                              h5("Constante C:"),
                                              HTML("</span>"),
                                              numericInput("Creal", "Parte Real:", value = -0.835,
                                                           min = -1.5, max = 1.5, step = 0.01),
                                              numericInput("Cimag", "Parte Imaginaria:", value = -0.232,
                                                           min = -1.5, max = 1.5, step = 0.01),
                                              hr(),
                                              HTML("<span style='color:white'>"),
                                              h5("Parámetros:"),
                                              HTML("</span>"),
                                              numericInput("potencia", "Potencia:", value = 2,
                                                           min = 1, max = 10, step = 1),
                                              numericInput("iteracion", "N° Iteraciones:", value = 20,
                                                           min = 1, max = 100, step = 1),
                                              numericInput("zoom", "Zoom:", value = 1.5, 
                                                           min = 0.5, max = 5.0, step = 0.1),
                                              numericInput("size", "Tamaño:", value = 500, 
                                                           min = 250, max = 1500, step = 50),
                                              hr()
                                              ),
                                        mainPanel(
                                              fluidRow(
                                                    column(width = 5,offset = 1,
                                                           selectInput("fractal", "Escoje el tipo de fractal:",
                                                                       choices = c("Julia", "Maldenbrot"))
                                                           ),
                                                    column(width = 5,
                                                           offset = 0,
                                                           selectInput("funcion", "Escoje una función",
                                                                       choices = c("Polinómica", "Fracción Polinómica I", "Fracción Polinómica II",
                                                                                   "Exponencial", "Seno Hiperbólico"))
                                                           ),
                                                    column(width = 2, 
                                                           offset = 1,
                                                           submitButton(text = "Ejecutar", icon = NULL, width = NULL)
                                                    )
                                                    ),
                                              fluidRow(
                                                    column(width = 12, offset = 1,
                                                           hr(),
                                                           HTML("<span style='color:white'>"),
                                                           displayOutput("widget")                                                    )
                                              )
                                              )
                                        )
                                  )
                                  )
                            ),
                   tabPanel("Información",
                            fluidPage(
                                  HTML("<span style='color:white'>"),
                                  h2("Resumen"),
                                  HTML("<span>"),
                                  
                                  HTML("<span style='color:lightsteelblue'>"),
                                  h5("La siguiente aplicación genera fractales no 
                                     lineales a partir de los Conjuntos de Julia y 
                                     Maldenbrot. Se presentan un conjunto de funciones
                                     genéricas que entrega un fractal en particular
                                     de acuerdo a los parámetros seleccionados para cada 
                                     función.",
                                     align = "justify"),
                                  
                                  HTML("<span style='color:white'>"),
                                  h2("Cómo utilizar esta aplicación"),
                                  HTML("<span>"),
                                  
                                  HTML("<span style='color:lightsteelblue'>"),
                                  h5("Para comenzar se debe escojer el tipo de fractal
                                     a representar, hay 2 opciones Julia(por defecto)
                                     y Maldenbrot.",
                                     align = "justify"),
                                  h5("Posteriormente se debe seleccionar una de las
                                     5 funciones disponibles (Polinómica, Fracción Polinómica I,
                                     Fracción Polinómica II, Exponencial y Seno Hiperbólico), para
                                     luego ajustar los parámetros correspondientes.",
                                     align = "justify"),
                                  h5("El primer parámetro es la constante compleja C, 
                                     esta afecta sólo al Fractal de Julia y una variación 
                                     pequeña puede afectar significativamente el resultado
                                     del fractal.",
                                     align = "justify"),
                                  h5("El parámetro potencia es el valor al que se eleva
                                     el valor complejo Z. Excepcionalmente para la función
                                     Seno Hiperbólico se eleva la función completa. Su rango es
                                     de 1 a 10.",
                                     align = "justify"),
                                  h5("El número de iteraciones indica para cuantas iteraciones
                                     se calculará el fractal. Modificar con precaución, ya que considerar que el tiempo 
                                     de ejecución del algoritmo depende de este 
                                     valor de manera directa.",
                                     align = "justify"),
                                  h5("El zoom es el tamaño en que se representará el fractal
                                     en la imagen, por defecto es 1.5 que normalmente funciona bien.
                                     Para algunos fractales puede ser necesario alejar el zoom
                                     aumentando el valor de este parámetro (máximo 5).",
                                     align = "justify"),
                                  h5("Por defecto las imágenes mostradas son de 500x500 píxeles.
                                     Se puede modificar este tamaño desde 250 hasta 1500, modificar con precaución
                                     ya que puede ralentizar el cálculo debido a que el tiempo es 
                                     proporcional al tamaño al cuadrado.",
                                     align = "justify"),
                                  h5("Luego se elegir el fractal, la función y el valor de cada
                                     parámetro se debe ejecutar el cálculo que se mostrará en pantalla.",
                                     align = "justify"),
                                  HTML("<span>"),
                                  HTML("<span style='color:white'>"),
                                  h2("Referencia"),
                                  HTML("<span>"),
                                  HTML("<span style='color:lightsteelblue'>"),
                                  h5("El código de esta aplicación se encuentra en:",
                                     align = "justify"),
                                  a("https://github.com/desareca/Fractales"),
                                  h5("Para mayor información sobre los fractales y funciones
                                     revisar:",
                                     align = "justify"),
                                  a("https://rpubs.com/desareca/Fractales"),
                                  HTML("<span>"),
                                  br(" "),
                                  br(" ")
                            )
                   )
                   )
       
        )