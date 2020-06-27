package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Institute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ClassDocumentDAO extends JpaRepository<Institute, Long>, JpaSpecificationExecutor<Institute> {
}
