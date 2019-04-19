library(tidyverse)

# Write matrix data
citations <- read_csv("graphs/graph_data/citations.csv")
matrix_data <- citations %>%
    group_by(paper_community, reference_community, year) %>%
    summarise(citations = sum(citations))
write_csv(matrix_data, "graphs/graph_data/matrix_data.csv")

# Write graph data
graph_data <- citations %>%
    mutate(
        pair = purrr::pmap_chr(
            .l = list(from = paper_venue, to = reference_venue),
            .f = function(from, to) paste(sort(c(from, to)), collapse = "_")
        )) %>%
    group_by(pair, year) %>%
    summarise(citations = sum(citations)) %>%
    separate(pair, c("source", "target"), sep = "_") %>%
    mutate(same_venue = source == target) %>%
    filter(same_venue == FALSE) %>%
    select(source, target, year, citations)
write_csv(graph_data, "graphs/graph_data/graph_data.csv")

# Write node data
paper_comm <- citations %>% select(paper_venue, paper_community)
ref_comm <- citations %>% select(reference_venue, reference_community)
names(paper_comm) <- c("name", "community")
names(ref_comm) <- c("name", "community")
comm_stacked <- rbind(paper_comm, ref_comm) %>%
    distinct()
write_csv(comm_stacked, "graphs/graph_data/node_info.csv")
