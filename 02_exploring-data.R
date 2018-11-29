if (!require("tidyverse")) install.packages("tidyverse")
if (!require("scales")) install.packages("scales")

theme_set(theme_light())

flora <- read_csv(file = "all_data_from_cnc_flora.csv")

# quantas espécies cada família tem nas categorias? 
flora %>% 
  count(family_name, sort = TRUE) %>% 
  View()

# quantas famílias em cada categoria?
flora %>%
  distinct(family_name, category) %>% 
  count(category, sort = TRUE) %>% 
  View()

flora %>%
  distinct(family_name, category) %>% 
  count(category, sort = TRUE) %>%
  ggplot(aes(x = reorder(category, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(title = "Quantas famílias em cada categoria?",
       x = "Categorias",
       y = "Número de espécies")

# quantas espécies em cada categoria?
flora %>%
  distinct(species, category) %>% 
  count(category, sort = TRUE) %>% 
  View()

flora %>%
  distinct(species, category) %>% 
  count(category, sort = TRUE) %>% 
  mutate(total = n/sum(n)) %>% 
  ggplot(aes(x = reorder(category, total), y = total)) +
  geom_col() +
  scale_y_continuous(labels = percent_format()) +
  coord_flip() +
  labs(title = "Quantas espécies em cada categoria?",
       x = "Categorias",
       y = "Número de espécies")
