#!/usr/bin/env Rscript
######################################################################################################################################
##########################                                                                                  ##########################
##########################                       Stream Benchmark Percentile Result                         ##########################
##########################                                                                                  ##########################
######################################################################################################################################


generateBenchmarkSpecificPercentile <- function(engines, tps, duration, percentile, tps_count, load_node_count){
  result <- NULL
  for(eng in seq_along(engines)){
    engine <- engines[eng]
    for(i in 1:tps_count) {
      TPS <- toString(tps * i)
      TPS
      reportFolder <- paste0("/Users/sahverdiyev/IdeaProjects/dnysus/streaming-benchmarks/result/")
      sourceFolder <- paste0("/Users/sahverdiyev/IdeaProjects/dnysus/streaming-benchmarks/result/", engine, "/TPS_", TPS, "_DURATION_", toString(duration), "/")
      Seen <- read.table(paste0(sourceFolder, "redis-seen.txt"), header=F, stringsAsFactors=F, sep=',')
      Updated <- read.table(paste0(sourceFolder, "redis-updated.txt"), header=F, stringsAsFactors=F, sep=',')

      SeenFiltered <- NULL
      UpdatedFiltered <- NULL
      for(c in 1:(length(Updated$V1)-1)) {
        if(Seen$V1[c] != Seen$V1[c+1] && Updated$V1[c] != Updated$V1[c+1] && Updated$V1[c] > 10000){
          SeenFiltered <- c(SeenFiltered, Seen$V1[c])
          UpdatedFiltered <- c(UpdatedFiltered, Updated$V1[c])
        }
      }
      UpdatedFiltered <- sort(UpdatedFiltered)
      df <- data.frame(tps*i*load_node_count, engine, UpdatedFiltered[round(percentile/100*(length(UpdatedFiltered)+1))]-10000)
      
      result <- rbind(result, df)
      df
      if (length(Seen$V1)  != length(Updated$V1)){ 
        stop("Input data set is wrong. Be sure you have selected correct collections")
      }
      names(df) <- c("TPS","Engine","Throughput")
    }
  }
  names(result) <- c("TPS","Engine","Throughput")
  ggplot(data=result, aes(x=TPS, y=Throughput, group=Engine, colour=Engine)) +
    geom_smooth(method="loess", se=F, size=0.5) +
    guides(fill=FALSE) +
    scale_y_continuous(breaks = round(seq(min(result$Throughput), max(result$Throughput), by = 10000), -4)) +
    scale_x_continuous(breaks = round(seq(min(result$TPS), max(result$TPS), by = tps*load_node_count), 1)) +
    xlab("Emit Rate (event/s)") + ylab("Latency (ms) ") +
    theme(plot.title = element_text(size = 8, face = "plain"), 
          axis.text.x = element_text(size = 6, angle = 30, hjust = 1), 
          text = element_text(size = 6, face = "plain"),
          legend.justification = c(0, 1), 
          legend.position = c(0, 1),
          legend.key.height=unit(0.5,"line"),
          legend.key.width=unit(0.5,"line"),
          legend.box.margin=margin(c(3,3,3,3)),
          legend.text=element_text(size=rel(0.7)))
  ggsave(paste0(duration, "_", percentile, "_percentile.pdf"), width = 8, height = 8, units = "cm", device = "pdf", path = reportFolder)
}

generateBenchmarkPercentile <- function(engine, tps, duration, tps_count, load_node_count){
  result <- NULL
  for(i in 1:tps_count) {
    TPS <- toString(tps * i)
    reportFolder <- paste0("/Users/sahverdiyev/IdeaProjects/dnysus/streaming-benchmarks/result/", engine, "/")
    sourceFolder <- paste0("/Users/sahverdiyev/IdeaProjects/dnysus/streaming-benchmarks/result/", engine, "/TPS_", TPS, "_DURATION_", toString(duration), "/")
    Seen <- read.table(paste0(sourceFolder, "redis-seen.txt"), header=F, stringsAsFactors=F, sep=',')
    Updated <- read.table(paste0(sourceFolder, "redis-updated.txt"), header=F, stringsAsFactors=F, sep=',')

    SeenFiltered <- NULL
    UpdatedFiltered <- NULL
    percentile <- NULL
    for(c in 1:(length(Updated$V1)-1)) {
      if(Seen$V1[c] != Seen$V1[c+1] && Updated$V1[c] != Updated$V1[c+1] && Updated$V1[c] > 10000){
        SeenFiltered <- c(SeenFiltered, Seen$V1[c])
        UpdatedFiltered <- c(UpdatedFiltered, Updated$V1[c])
      }
    }
    UpdatedFiltered <- sort(UpdatedFiltered)
    windows <- 1:99
    for(c in 1:99) {
      percentile[c] <- UpdatedFiltered[round(c/100*(length(UpdatedFiltered)+1))]
    }
    
    
    df <- data.frame(toString(tps*i*load_node_count), 1:99, percentile - 10000, windows)
    result <- rbind(result, df)
    
    if (length(Seen$V1)  != length(Updated$V1)){ 
      stop("Input data set is wrong. Be sure you have selected correct collections")
    }
    names(df) <- c("TPS","Seen","Throughput", "Percentile")
  }
  names(result) <- c("TPS","Seen","Throughput", "Percentile")
  #result = result[result$Throughput > 0,]
  ggplot(data=result, aes(x=Percentile, y=Throughput, group=TPS, colour=TPS)) + 
    geom_smooth(method="loess", se=F, size=0.5) + 
    scale_y_continuous(breaks= pretty_breaks()) +
    guides(fill=FALSE) +
    xlab("Percentile of Completed Tuple") + ylab("Latency (ms) ") +
    theme(plot.title = element_text(size = 8, face = "plain"), 
          text = element_text(size = 6, face = "plain"),
          legend.justification = c(0, 1), 
          legend.position = c(0, 1),
          legend.key.height=unit(0.5,"line"),
          legend.key.width=unit(0.5,"line"),
          legend.box.margin=margin(c(3,3,3,3)),
          legend.text=element_text(size=rel(0.7)))
  ggsave(paste0(engine, "_", duration, "_all_percentile.pdf"), width = 8, height = 8, units = "cm", device = "pdf", path = reportFolder)
}
