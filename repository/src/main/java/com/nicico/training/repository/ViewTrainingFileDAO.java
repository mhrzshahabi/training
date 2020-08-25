package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingFile;
import com.nicico.training.model.ViewTrainingPost;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewTrainingFileDAO extends BaseDAO<ViewTrainingFile, Long>, JpaSpecificationExecutor<ViewTrainingFile> {
}
