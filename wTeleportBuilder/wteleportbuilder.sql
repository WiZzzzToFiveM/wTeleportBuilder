CREATE TABLE `teleportbuilder` (
  `id` int(11) NOT NULL,
  `entrer` varchar(255) NOT NULL,
  `sortie` varchar(255) NOT NULL,
  `textentrer` varchar(50) NOT NULL,
  `textsortie` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `teleportbuilder`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `teleportbuilder`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;