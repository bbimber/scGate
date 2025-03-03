% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{scGate}
\alias{scGate}
\title{Filter single-cell data by cell type}
\usage{
scGate(
  data,
  model,
  pos.thr = 0.2,
  neg.thr = 0.2,
  assay = "DefaultAssay",
  ncores = 1,
  seed = 123,
  keep.ranks = FALSE,
  min.cells = 30,
  nfeatures = 2000,
  pca.dim = 30,
  resol = 3,
  output.col.name = "is.pure",
  by.knn = TRUE,
  k.param = 10,
  genes.blacklist = "default",
  additional.signatures = NULL,
  verbose = TRUE
)
}
\arguments{
\item{data}{Seurat object containing a query data set - filtering will be applied to this object}

\item{model}{A tabular model with scGate signatures. See Details for this format}

\item{pos.thr}{Minimum UCell score value for positive signatures}

\item{neg.thr}{Maximum UCell score value for negative signatures}

\item{assay}{Seurat assay to use}

\item{ncores}{Number of processors for parallel processing (requires \code{\link{future.apply}})}

\item{seed}{Integer seed for random number generator}

\item{keep.ranks}{Store UCell rankings in Seurat object. This will speed up calculations if the same object is applied again with new signatures.}

\item{min.cells}{Stop iterating if fewer than this number of cells is left}

\item{nfeatures}{Number of variable genes for dimensionality reduction}

\item{pca.dim}{Number of principal components for dimensionality reduction}

\item{resol}{Resolution for cluster analysis (if \code{by.knn=FALSE})}

\item{output.col.name}{Column name with 'pure/impure' annotation}

\item{by.knn}{Perform k-nearest neighbor smoothing for UCell scores}

\item{k.param}{Number of nearest neighbors for knn smoothing}

\item{genes.blacklist}{Genes blacklisted from variable features. The default loads the list of genes in \code{scGate::genes.blacklist.default};
you may deactivate blacklisting by setting \code{genes.blacklist=NULL}}

\item{additional.signatures}{A list of additional signatures, not included in the model, to be evaluated (e.g. a cycling signature). The scores for this
list of signatures will be returned but not used for filtering.}

\item{verbose}{Verbose output}
}
\value{
A new metadata column \code{is.pure} is added to the query Seurat object, indicating which cells correspond to the desidered cell type(s).
    The \code{active.ident} is also set to this variable.
}
\description{
Apply scGate to filter specific cell types in a query dataset
}
\details{
Models for scGate are dataframes where each line is a signature for a given filtering level. A database of models can be downloaded using the function
    \code{get_scGateDB()}. You may directly use the models from the database, or edit one of these models to generate your own custom gating model.
}
\examples{
library(scGate)
testing.datasets <- get_testing_data(version = 'hsa.latest') # get some testing datasets
seurat_object <- testing.datasets[["Satija"]]
my_scGate_model <- gating_model(name = "Bcell", signature = c("MS4A1")) # define basic gating model for B cells
seurat_object <- scGate(data = seurat_object, model = my_scGate_model) # gate it!
table(seurat_object$is.pure)
DimPlot(seurat_object)
seurat_object_filtered <- subset(seurat_object, subset=is.pure=="Pure") # create a subsetted Seurat object with gated population

############
# Using pre-defined models

models <- get_scGateDB()
seurat_object <- scGate(seurat_object, model=models$human$generic$PanBcell)
DimPlot(seurat_object)
seurat_object_filtered <- subset(seurat_object, subset=is.pure=="Pure")

############
# Tree-like model visualization

plot_tree(models$human$generic$PanBcell) 

############
# Using a manually edited model

my_scGate_model <- load_scGate_model("custom_model.tsv")
seurat_object <- scGate(seurat_object, model=my_scGate_model)
seurat_object_filtered <- subset(seurat_object, subset=is.pure=="Pure")



}
\seealso{
\code{\link{load_scGate_model}} \code{\link{get_scGateDB}} \code{\link{plot_tree}}
}
