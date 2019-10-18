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
# paleta de colores
rand_col <- function(n = 64, seed = 123, random = TRUE,
                     col1 = "#2F184F", col2 = "green", col3 = "blue"){
      if(!is.null(seed)){set.seed(seed)}
      hex = c("0","1","2","3","4","5","6","7",
              "8","9","A","B","C","D","E","F")
      addalpha <- function(colors, alpha=1.0) {
            r <- col2rgb(colors, alpha=T)
            # Apply alpha
            r[4,] <- alpha*255
            r <- r/255.0
            return(rgb(r[1,], r[2,], r[3,], r[4,]))
      }
      if(random){
            col1 <- paste(c("#",sample(hex,6)),sep = "", collapse = "")
            col2 <- paste(c("#",sample(hex,6)),sep = "", collapse = "")
            col3 <- paste(c("#",sample(hex,6)),sep = "", collapse = "")
      }
      cr1 <- c(addalpha(col1, 0.5),
               col2,
               addalpha(col3, 0.35))
      cols <- colorRampPalette(cr1)(n)
}
# Algoritmo fractal de Julia
algosJuliaT <- function(funcion, C = complex(real=-0.8, imag=0.156),
                        m = 500, n = 20, r = 1.5, gamma = 0.7,
                        stop = 1.0, verbose = FALSE){
      # Variables:
      # ------------------------------------------------------------------------
      # funcion:   función a utilizar en el fractal.
      # C:         constante compleja.
      # m:         resolución de la matriz (mxm).
      # n:         número de iteraciones.
      # r:         rango de la matriz Z en el plano complejo, desde -r a r para
      #            reales como imaginarios.
      # gamma:     ajusta la inclinación de la función exponencial.
      # stop:      detiene el algoritmo cuando la suma de los ceros es mayor 
      #            o igual al umbral, 93% por defecto.
      # verbose:   muestra el avance de las iteraciones.
      
      # nota1:     la salida de la función utiliza una exponencial para 
      #            acotar el rango de salida entre 0 y 1.
      # nota2:     los argumentos de la función deben considerar z como la 
      #            variable iterativa, c como la constante, k como un argumento 
      #            dependiente de la iteración (es opcional).
      if(is.null(funcion)){return("Ingresar función a calcular")}
      if(!is.null(funcion)){
            Z <- complex(real=rep(seq(-r,r, length.out=m), each=m),
                         imag=rep(seq(-r,r, length.out=m), m))
            Z <- matrix(Z,m,m)
            ZZ <- Z
            X <- array(0, c(m,m,0))
            if(verbose){
                  pb <- txtProgressBar(min = 0, max = n, style = 3, initial = 0)
            }
            for (k in 1:n) {
                  Z <- funcion(z=Z,c=C, k=k)
                  Z[is.na(Mod(Z))] <- max(Re(Z[!is.na(Z)])) + 1i*max(Im(Z[!is.na(Z)]))
                  if(sum(exp(-gamma*abs(Z))==0)<=stop*m*m){
                        X <- abind(X, exp(-gamma*abs(Z)), along = 3)
                  }
                  if(sum(exp(-gamma*abs(Z))==0)>stop*m*m){k <- n}
                  if(verbose){setTxtProgressBar(pb, k)}
            }
            if(verbose){close(pb)}
            return(X)     
      }
}
# Algoritmo fractal de Maldenbrot
algosMaldenbrotT <- function(funcion, m = 500, n = 20, C=0,
                             stop = 0.0, r = 1.5, gamma = 0.7,
                             verbose = FALSE){
      # Variables:
      #-----------
      # funcion:   función a utilizar en el fractal.
      # m:         resolución de la matriz (mxm).
      # n:         número de iteraciones.
      # r:         rango de la matriz Z, desde -r a r, para reales 
      #            como imaginarios.
      # gamma:     ajusta la inclinación de la función exponencial.
      
      # nota1:    la salida de la función utiliza una exponencial para 
      #           acotar el rango de salida entre 0 y 1.
      # nota2:    los argumentos de la función deben considerar z como la variable
      #           iterativa, p como la potencia u otro 
      #           que se considere necesario (es opcional), k como un argumento 
      #           dependiente de la iteración (es opcional).
      if(is.null(funcion)){return("Ingresar función a calcular")}
      if(!is.null(funcion)){
            CC <- matrix(0,m,m)
            for (i in 1:m) {
                  for (j in 1:m) {
                        CC[i,j] <- (i-m/2)*2/m + 1i*(j-m/2)*2/m
                  }
            }
            CC <- CC*r
            Z <- matrix(0,m,m)
            X <- array(0, c(m,m,0))
            Xo <- array(1,c(m,m,1))
            if(verbose){pb <- txtProgressBar(min = 0, max = n, style = 3, initial = 0)}
            for (k in 1:n) {
                  Z <- funcion(z=Z,c=CC, k=k)
                  Z[is.na(Mod(Z))] <- max(Re(Z[!is.na(Z)])) + 1i*max(Im(Z[!is.na(Z)]))
                  Xf <- array(exp(-gamma*abs(Z)), dim = c(m,m,1))
                  if(sum(abs(Xf-Xo))<stop*m*m){
                        k <- n
                        break()
                  }
                  
                  if(sum(abs(Xf-Xo))>=stop*m*m){
                        X <- abind(X, Xf, along = 3)
                        Xo <- Xf
                  }
                  if(verbose){setTxtProgressBar(pb, k)}
            }
            if(verbose){setTxtProgressBar(pb, n)}
            if(verbose){close(pb)}
            return(X)
      }
}



# Define server logic required to predict next word
shinyServer(function(input, output) {
      img <- reactive({
            if(input$fractal=="Julia"){
                  if(input$funcion=="Polinómica"){
                        a<-algosJuliaT(funcion = function(z,c,k){z^(input$potencia) + c},
                                    C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                    r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Fracción Polinómica I"){
                        a<-algosJuliaT(funcion = function(z,c,k){(z^(input$potencia) + c)/(z^(input$potencia) - c)},
                                    C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                    r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Fracción Polinómica II"){
                        a<-algosJuliaT(funcion = function(z,c,k){(z^(input$potencia) + c)/(z+0.0001)},
                                    C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                    r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Exponencial"){
                        a<-algosJuliaT(funcion = function(z,c,k){exp(z^(input$potencia))+c},
                                    C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                    r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Seno Hiperbólico"){
                        a<-algosJuliaT(funcion = function(z,c,k){sinh(z+c)^(input$potencia)},
                                    C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                    r = input$zoom, m = input$size)
                  }
            }
            if(input$fractal=="Maldenbrot"){
                  if(input$funcion=="Polinómica"){
                        a<-algosMaldenbrotT(funcion = function(z,c,k){z^(input$potencia) + c},
                                       C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                       r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Fracción Polinómica I"){
                        a<-algosMaldenbrotT(funcion = function(z,c,k){(z^(input$potencia) + c)/(z^(input$potencia) - c)},
                                       C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                       r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Fracción Polinómica II"){
                        a<-algosMaldenbrotT(funcion = function(z,c,k){(z^(input$potencia) + c)/(z+0.0001)},
                                       C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                       r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Exponencial"){
                        a<-algosMaldenbrotT(funcion = function(z,c,k){exp(z^(input$potencia))+c},
                                       C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                       r = input$zoom, m = input$size)
                  }
                  if(input$funcion=="Seno Hiperbólico"){
                        a<-algosMaldenbrotT(funcion = function(z,c,k){sinh(z+c)^(input$potencia)},
                                       C = input$Creal + 1i*input$Cimag, n = input$iteracion,
                                       r = input$zoom, m = input$size)
                  }
            }
            return(a)
      })
      
      output$widget <- renderDisplay({
            req(img())
            img_temp <- colormap(img(), rand_col(random = FALSE))
            display(img_temp, method = "browser")
      })
})
