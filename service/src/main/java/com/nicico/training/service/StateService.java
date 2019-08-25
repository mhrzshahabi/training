package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CityDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import com.nicico.training.dto.StateDTO;
import com.nicico.training.iservice.IStateService;
import com.nicico.training.model.City;
import com.nicico.training.model.EducationMajor;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.model.State;
import com.nicico.training.repository.StateDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class StateService implements IStateService {
    private final ModelMapper modelMapper;
    private final StateDAO stateDAO;

    @Transactional(readOnly = true)
    @Override
    public StateDTO.Info get(Long id) {
        final Optional<State> gById = stateDAO.findById(id);
        final State state = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StateNotFound));
        return modelMapper.map(state, StateDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<StateDTO.Info> list() {
        final List<State> gAll = stateDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<StateDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public StateDTO.Info create(StateDTO.Create request) {
        final State state = modelMapper.map(request, State.class);
        return save(state);
    }

    @Transactional
    @Override
    public StateDTO.Info update(Long id, StateDTO.Update request) {
        final Optional<State> cById = stateDAO.findById(id);
        final State state = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        State updating = new State();
        modelMapper.map(state, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<State> one = stateDAO.findById(id);
        final State state = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        stateDAO.delete(state);
    }

    @Transactional
    @Override
    public void delete(StateDTO.Delete request) {
        final List<State> gAllById = stateDAO.findAllById(request.getIds());
        stateDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<StateDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(stateDAO, request, state -> modelMapper.map(state, StateDTO.Info.class));
    }

    // ------------------------------

    private StateDTO.Info save(State state) {
        final State saved = stateDAO.saveAndFlush(state);
        return modelMapper.map(saved, StateDTO.Info.class);
    }

    @Transactional
    @Override
    public List<CityDTO.Info> listByStateId(Long stateId) {
        final Optional<State> cById = stateDAO.findById(stateId);
        final State one = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Set<City> cities = one.getCitySet();
        List<CityDTO.Info> cityInfo = new ArrayList<>();
        Optional.ofNullable(cities)
                .ifPresent(cityList ->
                        cityList.forEach(city ->
                                cityInfo.add(modelMapper.map(city, CityDTO.Info.class))
                        ));
        return cityInfo;
    }
}
