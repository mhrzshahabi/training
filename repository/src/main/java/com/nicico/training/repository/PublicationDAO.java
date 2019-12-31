package com.nicico.training.repository;

import com.nicico.training.model.Publication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PublicationDAO extends JpaRepository<Publication, Long>, JpaSpecificationExecutor<Publication> {
}
