module Common where

  -- Comandos interactivos o de archivos
  data Stmt i = Def String i           --  Declarar un nuevo identificador x, let x = t
              | Eval i                 --  Evaluar el término
    deriving (Show)
  
  instance Functor Stmt where
    fmap f (Def s i) = Def s (f i)
    fmap f (Eval i)  = Eval (f i)

  -- Tipos de los nombres
  data Name
     =  Global  String
     |  Quote   Int
    deriving (Show, Eq)

  -- Entornos
  type NameEnv v t = [(Name, (v, t))]

  -- Tipo de los tipos
  data Type = Base 
            | Fun Type Type

            deriving (Show, Eq)
  
  -- Términos con nombres
  data LamTerm  =  LVar String
                |  Abs String Type LamTerm
                |  App LamTerm LamTerm
                |  LetLT String LamTerm LamTerm 
                |  AsLT Type LamTerm 
                deriving (Show, Eq)


  -- Términos localmente sin nombres
  data Term  = Bound Int
             | Free Name 
             | Term :@: Term
             | Lam Type Term
             | LetT Term Term
             | AsT Type Term 
          deriving (Show, Eq)

  -- Valores
  data Value = VLam Type Term 
             | VUnit 



  -- Contextos del tipado
  type Context = [Type]



-- infer [(Global "hola",(VUnit,Base))] (Free (Global "hola"))

-- El funcionamiento de (>>=) es como el "pasaje de argumentos " es decir si pones t (>>=) f , f toma el argumento que da como resultado la evaluacion de t
--infer' c e (t :@: u) = infer' c e t >>= \tt -> 
--                       infer' c e u >>= \tu ->
--                       case tt of
--                         Fun t1 t2 -> if (tu == t1) 
--                                        then ret t2
--                                        else matchError t1 tu
--                         _         -> notfunError tt

-- este caso ponele q agarra, infiere el tipo de t, le pasa el valor a la funcion q toma este tipo  e infiere el de u , y le pasa el resultado a una funcion q toma el tipo ese de u, tu, y compara
-- lo cual tiene sentido ya q si es una aplicacion por ejemplo "a b" puede ser de tipo a: Fun Base Base y b : Base , por lo que te compara t1 (el valor que debe tomar la funcion a con b el valor que toma
-- Esta linea basicamente es la regla T-ABS 


