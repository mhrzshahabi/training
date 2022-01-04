package com.nicico.training.repository;

import com.nicico.training.model.FileLabel;
import com.nicico.training.model.HelpFiles;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface HelpFilesDAO extends JpaRepository<HelpFiles, Long> {

    Set<HelpFiles> findAllByFileLabelsIn(Set<FileLabel> fileLabels);
}
