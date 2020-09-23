package com.nicico.training.service;
/* com.nicico.training.service
@Author:Lotfy
*/

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.repository.PersonnelRegisteredDAO;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PersonnelRegisteredService implements IPersonnelRegisteredService {

    private final ModelMapper modelMapper;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;

    //Unused
    @Transactional(readOnly = true)
    @Override
    public PersonnelRegisteredDTO.Info get(Long id) {
        final Optional<PersonnelRegistered> gById = personnelRegisteredDAO.findById(id);
        final PersonnelRegistered personnelRegistered = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PersonnelRegisteredNotFound));
        return modelMapper.map(personnelRegistered, PersonnelRegisteredDTO.Info.class);
    }

    //Unused
    @Transactional(readOnly = true)
    @Override
    public List<PersonnelRegisteredDTO.Info> list() {
        final List<PersonnelRegistered> gAll = personnelRegisteredDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<PersonnelRegisteredDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public PersonnelRegisteredDTO.Info create(PersonnelRegisteredDTO.Create request) {
        final PersonnelRegistered personnelRegistered = modelMapper.map(request, PersonnelRegistered.class);
        personnelRegistered.setActive(1);
        return save(personnelRegistered);
    }

    @Transactional
    @Override
    public PersonnelRegisteredDTO.Info update(Long id, PersonnelRegisteredDTO.Update request) {
        final Optional<PersonnelRegistered> cById = personnelRegisteredDAO.findById(id);
        final PersonnelRegistered personnelRegistered = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        PersonnelRegistered updating = new PersonnelRegistered();
        modelMapper.map(personnelRegistered, updating);
        modelMapper.map(request, updating);
        updating.setActive(1);

        if (updating.getEnabled() == 494) {
            updating.setEnabled(null);
        }

        if (updating.getDeleted() == 76) {
            updating.setDeleted(null);
        }

        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        personnelRegisteredDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(PersonnelRegisteredDTO.Delete request) {
        final List<PersonnelRegistered> gAllById = personnelRegisteredDAO.findAllById(request.getIds());
        personnelRegisteredDAO.deleteAll(gAllById);
    }

    //TODO:must be check
    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelRegisteredDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(personnelRegisteredDAO, request, personnelRegistered -> modelMapper.map(personnelRegistered, PersonnelRegisteredDTO.Info.class));
    }

    //unused
    @Transactional(readOnly = true)
    @Override
    public TotalResponse<PersonnelRegisteredDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(personnelRegisteredDAO, request, Personnel -> modelMapper.map(Personnel, PersonnelRegisteredDTO.Info.class));
    }

    @Transactional
    @Override
    public List<PersonnelRegisteredDTO.InfoForStudent> checkPersonnelNos(List<String> personnelNos, Long courseId) {
        List<PersonnelRegisteredDTO.InfoForStudent> result = new ArrayList<>();

        List<PersonnelRegistered> list = personnelRegisteredDAO.findByPersonnelNoInOrPersonnelNo2In(personnelNos, personnelNos);
        PersonnelRegistered prs = null;

        for (String personnelNo : personnelNos) {
            List<PersonnelRegistered> list2 = list.stream().filter(p -> (p.getDeleted() == null) && (p.getPersonnelNo() != null && p.getPersonnelNo().equals(personnelNo)) || (p.getPersonnelNo2() != null && p.getPersonnelNo2().equals(personnelNo))).collect(Collectors.toList());
            if (list2.size() == 0){
                result.add(new PersonnelRegisteredDTO.InfoForStudent());

            } else{
                prs = list2.get(0);
                result.add(modelMapper.map(prs, PersonnelRegisteredDTO.InfoForStudent.class));
            }
        }

        return result;
    }

    //unUsed
    @Override
    public PersonnelRegisteredDTO.Info getOneByNationalCode(String nationalCode) {
        return null;
    }

    // ------------------------------

    private PersonnelRegisteredDTO.Info save(PersonnelRegistered personnelRegistered) {
        final PersonnelRegistered saved = personnelRegisteredDAO.saveAndFlush(personnelRegistered);
        return modelMapper.map(saved, PersonnelRegisteredDTO.Info.class);
    }

    //unUsed
    @Override
    @Transactional
    public PersonnelRegisteredDTO.Info getByPersonnelCode(String personnelCode) {
        Optional<PersonnelRegistered> optPersonnel = personnelRegisteredDAO.findOneByPersonnelNo(personnelCode);
        final PersonnelRegistered personnel = optPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(personnel, PersonnelRegisteredDTO.Info.class);
    }

    @Override
    @Transactional
    public PersonnelRegisteredDTO.Info getByPersonnelCodeAndNationalCode(String nationalCode, String personnelNo) {

        PersonnelRegistered personnelRegistered = null;
        List<PersonnelRegistered> personnelsRegistereds = null;

        if (StringUtils.isNotEmpty(nationalCode)) {

            personnelsRegistereds = personnelRegisteredDAO.findAllByNationalCodeOrderByIdDesc(nationalCode);

            personnelRegistered = personnelsRegistereds.stream().filter(p -> p.getDeleted() == null).findFirst().orElse(null);

            if (personnelRegistered == null) {
                if (personnelsRegistereds.size() > 0) {
                    personnelRegistered = personnelsRegistereds.get(0);
                }
            }

        } else {
            personnelsRegistereds = personnelRegisteredDAO.findAllByPersonnelNoOrderByIdDesc(personnelNo);

            personnelRegistered = personnelsRegistereds.stream().filter(p -> p.getDeleted() == null).findFirst().orElse(null);

            if (personnelsRegistereds == null) {
                if (personnelsRegistereds.size() > 0) {
                    personnelRegistered = personnelsRegistereds.get(0);
                }
            }
        }

        return modelMapper.map(personnelRegistered, PersonnelRegisteredDTO.Info.class);
    }

}
