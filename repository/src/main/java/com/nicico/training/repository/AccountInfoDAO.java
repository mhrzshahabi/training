package com.nicico.training.repository;

import com.nicico.training.model.AccountInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import org.springframework.data.domain.Pageable;
import java.util.List;

@Repository
public interface AccountInfoDAO extends JpaRepository<AccountInfo, Long>, JpaSpecificationExecutor<AccountInfo> {

    List<AccountInfo> findAllByInstituteId(Long id, Pageable pageable);
    List<AccountInfo> getAllByInstituteId(long instituteId);
}
