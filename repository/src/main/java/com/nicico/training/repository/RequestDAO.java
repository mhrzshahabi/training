package com.nicico.training.repository;

import com.nicico.training.model.Request;
import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.RequestType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import java.util.List;
import java.util.Optional;

@Repository
public interface RequestDAO extends JpaRepository<Request, Long> {

    List<Request> findAllByNationalCode(String nationalCode);

    Optional<Request> findByReference(String nationalCode);

    List<Request> findAllByStatus(RequestStatus status);

    List<Request> findAllByType(RequestType type);

    List<Request> findAllByNationalCodeAndStatus(String nationalCode, RequestStatus status);

    List<Request> findAllByNationalCodeAndType(String nationalCode, RequestType requestType);
}
